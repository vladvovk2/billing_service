### Subscription Billing System
This project is a subscription billing system that automates customer billing, tracks payment statuses, and handles transaction processing. The service includes tables for managing customer subscriptions, billing periods, and individual transaction details.

#### Installation Guide
Follow these steps to set up the project locally using Docker.

```bash
# Step 1: Initialize environment variables for the API service and the database
cat env/.env.api.example >> env/.env.api.development
cat env/.env.database.example >> env/.env.database.development

# Step 2: Build the project with Docker
docker-compose up --build

# Step 3: Create the database, run migrations, and seed initial data
docker exec -it api sh ./initialize.sh
```

### Table Descriptions

#### Subscriptions Table
The subscriptions table stores information about each user’s subscription, including details about their payment method, subscription status, and chosen plan.

#### Billing Periods Table
The billing_periods table tracks each subscription’s billing cycle details, such as the due amount, amount paid, and the payment status for each billing period.

#### Transactions Table
The transactions table logs individual transactions for each billing period, capturing details such as the transaction amount, status, and payment method used.

```mermaid

erDiagram
    subscriptions {
        int user_id
        enum plan
        decimal amount
        date next_billing_date
        string payment_method
    }

    billing_periods {
        decimal amount_due
        decimal amount_paid
        enum status
        string billing_period
    }

    transactions {
        uuid token
        int  billing_period_id
        decimal amount
        integer status
        varchar payment_method
    }

    subscriptions ||--o{ billing_periods : "has many"
    billing_periods ||--o{ transactions : "has many"
```

### Workflow
The main idea is to have a service that, using a cron job, will charge subscription fees according to the billing date. Before processing a payment, we validate all the conditions required to proceed.
Among these conditions, we check if there have been 4 or more transactions with an “insufficient funds” status for the given subscription in the current billing period.
After validation, we calculate the amount due, which may vary depending on the status of previous transactions, subscription plan etc. Once the amount is calculated, we initialize the payment gateway responsible for processing the payment for current subscription.
After the payment is processed, we handle the result and, depending on the transaction status, take appropriate actions, such as scheduling the next payment in case of a successful transaction or scheduling a retry in case of a failed transaction, and so on.

```mermaid
flowchart TD
    subgraph SubscriptionBillingSchedulerWorker
        AA[Fetch Active Subscriptions with Unpaid Current Billing Period]
    end

    subgraph SubscriptionChargeWorker
        AA --> BA[Validate Subscription Status]
        BA --> BB{Valid?}

        BB -->|Yes| BC[Proceed to Create Payment Intent]
        BB -->|No| BD[END]
        BE[Handle Payment Intent Result]
    end

    subgraph SubscriptionValidatorService
        BA --> CA[Subscription Active?]
        CA --> CB[Billing Period Already Paid?]
        CB --> CC[Payment Attempt Limit Exceeded?]
    end

    subgraph PaymentProcessorService
        BC --> DA[Calculate Billing Amount]
        DA --> DB[Initialize Payment Gateway]
        DB --> DC[Make an attempt to create payment intent]
        DC --> BE
    end


    subgraph BillingAmountCalculatorService
        DA --> EB[Check Billing Period Status]
        EB -->|Pending| EC[Calculate Pending Amount]
        EB -->|Partialy Paid| EE[Calculate Partially Paid Amount]
        EC --> EG[Multiply Amount Due by Charge Fraction]
        EE --> EH[Subtract Amount Paid from Amount Due]

        EG --> EI[Calculate Amount to Charge Fraction Based on Insufficient Funds Transactions Count]
    end

    subgraph PaymentGatewayFactory
        DB --> FA[Check PaymentGateway Customer Has]

        FA -->|Stripe| FB[Initialize Stripe PaymentGatway]
        FA -->|PayPal| FC[Initialize PayPal PaymentGatway]
    end

    subgraph PaymentResultHandler
        BE --> GA[Choose How to Handle Payment Intent Result Depending On Status]
    end

    subgraph StatusHandlers::Success
        GA --> |Success| HA[Start Success Status Handler]
        HA --> HB[Update Billing Information]
        HB --> HC[Schedule Next Billing Date]
        HC --> |Fully Paid Subscription| HD[1 Month]
        HC --> |Partially Paid Subscription| HE[7 Days]

        HD --> HF
        HE --> HF
        HF[Schedule] --> AA
    end

    subgraph StatusHandlers::Failed
        GA --> |Failed| IB[Update Transaction Status to Failed]
        IB --> ID[Schedule Payment Retry]
        ID --> BA
    end

    subgraph StatusHandlers::InsufficientFunds
        GA --> |Insufficient Funds| JA[Update Transaction Status to Failed]
        JA --> JD[Schedule Payment Retry]
        JD --> BA
    end

    subgraph StatusHandlers::Unexpected
        GA --> |Unexpected or Aborted| KA[Update Transaction Status to Aborted]
        KA --> KD[Trigger Flow to Found Out Current Status of Aborted Transaction]
    end
```
