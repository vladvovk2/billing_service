class SubscriptionValidatorService
  def initialize(subscription, logger)
    @subscription = subscription
    @logger = logger
  end

  def call
    validator = SubscriptionValidation.new(@subscription)
    validator.validate!

    if validator.valid?
      @logger.info("Subscription is valid and ready to be processed.")
      true
    else
      @logger.error("Subscription is not valid due to the following reasons: #{validator.full_error_messages}")
      false
    end
  end
end