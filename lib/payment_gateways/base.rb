module PaymentGateways
  class Base
    def charge(subscription_id, amount)
      raise NotImplementedError
    end

    def code
      raise NotImplementedError
    end

    def transaction_details
      raise NotImplementedError
    end

    def client
      raise NotImplementedError
    end

    def handle_response(response)
      raise NotImplementedError
    end
  end
end