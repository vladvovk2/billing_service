class PaymentProcessorService
  def initialize(subscription, logger)
    @subscription = subscription
    @logger = logger
  end

  def process_payment
    billing_amount = BillingAmountCalculatorService.new(@subscription).call
    @logger.info(time: Time.now, message: "Calculated billing amount: #{billing_amount}")

    payment_gateway = PaymentGatewayFactory.new(@subscription.payment_method)
    @logger.info(time: Time.now, message: "Initialized payment gateway: #{payment_gateway.name}")

    @logger.info(time: Time.now, message: "Attempt to charge customer subscription amount.")
    payment_gateway.charge(@subscription.id, billing_amount)

    handler = PaymentResultHandler.new(@subscription, payment_gateway.transaction_details, @logger)
    handler.call
  end
end