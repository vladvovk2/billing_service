module StatusHandlers
  class InsufficientFunds < Base
    def handle
      update_billing_data
    end

    private

    def update_billing_data
      update_transaction_status
      log_payment_status
      schedule_payment_retry
    end

    def update_transaction_status
      billing_period.transactions.create(token: @transaction['token'], amount: 0, status: :insufficient_funds)
    end

    def billing_period
      @billing_period ||= @subscription.billing_periods.current
    end

    def schedule_payment_retry
      SubscriptionChargeWorker.perform_in(1.hour, @subscription.id)
    end

    def log_payment_status
      @logger.warn(time: Time.now, message: status_message, attributes: @transaction)
    end

    def status_message
      "Insufficient funds to charge the remaining balance for subscription."
    end
  end
end