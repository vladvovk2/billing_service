module StatusHandlers
  class Success < Base
    def handle
      update_billing_data
    end

    private


    def update_billing_data
      ActiveRecord::Base.transaction do
        update_transaction_status
        update_subscription
        update_billing_period
      end

      log_payment_status
    end

    def update_subscription
      @subscription.update(next_billing_date: Date.today + next_billing_interval)
    end

    def update_billing_period
      billing_period.update(status: billing_status, amount_paid: amount_paid)
    end

    def update_transaction_status
      billing_period.transactions.create(token: @transaction['token'], amount: @transaction['amount'], status: :success)
    end

    # Schedule class could be implemented instead of this method
    def next_billing_interval
      subscription_fully_paid? ? 1.month : 7.days
    end

    def billing_status
      subscription_fully_paid? ? :paid : :partially_paid
    end

    def subscription_fully_paid?
      billing_period.amount_due.eql?(paid_amount)
    end

    def amount_paid
      @amount_paid ||= billing_period.transactions.where(status: :success).sum(:amount)
    end

    def billing_period
      @billing_period ||= @subscription.billing_periods.current
    end

    def log_payment_status
      @logger.info(time: Time.now, message: status_message, attributes: @transaction)
    end

    def status_message
      subscription_fully_paid? ? "Subscription successfully paid." : "Subscription partially paid."
    end
  end
end
