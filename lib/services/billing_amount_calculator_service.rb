class BillingAmountCalculatorService
  def initialize(subscription)
    @subscription = subscription
  end

  # Calculation could be more complex and processed with different services
  # depending on the subscription plans, billing periods etc.

  def call
    CalculateBillingAmount.new(@subscription).amount
  end
end