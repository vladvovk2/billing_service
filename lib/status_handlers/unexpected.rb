module StatusHandlers
  class Unexpected < Base
    def handle
      # Implement the logic to handle unexpected transaction statuses.
      # It should check if transaction processed successfully or not, set correct transaction status and update billing information.
      update_transaction_status

      log_payment_status
    end

    private

    def update_transaction_status
      billing_period.transactions.create(token: @transaction['token'], amount: 0, status: :aborted)
    end

    def billing_period
      @billing_period ||= @subscription.billing_periods.current
    end

    def log_payment_status
      @logger.warn(time: Time.now, message: status_message, attributes: @transaction)
    end

    def status_message
      "Unexpected transaction status."
    end
  end
end
