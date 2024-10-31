class PaymentResultHandler
  HANDLERS = {
    success: StatusHandlers::Success,
    failed: StatusHandlers::Failed,
    insufficient_funds: StatusHandlers::InsufficientFunds
  }.freeze

  def initialize(subscription, transaction, logger, handlers = HANDLERS)
    @transaction = transaction
    @subscription = subscription
    @logger = logger
    @handlers = handlers
  end

  def call
    execute_handler
  end

  private

  def handler_class
    @handlers.fetch(@transaction['status'].to_sym, StatusHandlers::Unexpected)
  end

  def execute_handler
    handler = handler_class.new(subscription: @subscription, transaction: @transaction, logger: @logger)
    handler.handle
  rescue StandardError => e
    @logger.error("Error handling payment result: #{e.message}")
  end
end