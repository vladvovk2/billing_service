module StatusHandlers
  class Failed < Base
    def handle
      # Is there any other action required to handle failed transaction status? For example make subscription inactive, notify customer etc.

      update_transaction_status
      log_payment_status
      schedule_payment_retry
    end

    private

    def update_transaction_status
      billing_period.transactions.create(token: @transaction['token'], amount: 0, status: :failed)
    end

    def schedule_payment_retry
      # Any formula to calculate the retry interval? For example, for the first time retry after 10 seconds,
      # then 1 minute, then 5 minutes, then 1 hour etc.
      SubscriptionChargeWorker.perform_in(1.seconds, @subscription.id)
    end

    def billing_period
      @billing_period ||= @subscription.billing_periods.current
    end

    def log_payment_status
      @logger.warn(time: Time.now, message: status_message, attributes: @transaction)
    end

    def status_message
      "Failed to charge the balance for subscription."
    end
  end
end
