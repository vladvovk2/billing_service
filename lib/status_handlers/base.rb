module StatusHandlers
  class Base
    def initialize(subscription:, transaction:, logger: Logger.new(STDOUT))
      @subscription = subscription
      @transaction  = transaction
      @logger       = logger
    end

    def handle
      raise NotImplementedError
    end
  end
end
