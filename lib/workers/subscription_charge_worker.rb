class SubscriptionChargeWorker
  include Sidekiq::Worker

  queue_as :low

  def perform(subscription_id)
    @subscription_id = subscription_id

    if validate_subscription_status
      create_payment_intent
    else
      logger.error("Subscription validation failed. Payment intent not created.")
    end
  end

  private

  def validate_subscription_status
    SubscriptionValidatorService.new(subscription, logger).call
  end

  def create_payment_intent
    PaymentProcessorService.new(subscription, logger).process_payment
  end

  def subscription
    @subscription ||= Subscription.includes(billing_periods: :transactions)
                                  .find_by(id: @subscription_id)
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end
end
