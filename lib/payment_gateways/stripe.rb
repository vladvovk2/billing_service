module PaymentGateways
  class Stripe < Base
    CLIENT_URL = "http://host.docker.internal:3000/paymentIntents/create".freeze

    def charge(subscription_id, amount)
      response = client.post do |req|
        req.body = { subscription_id: subscription_id, amount: amount }.to_json
      end

      handle_response(response)
    end

    def code
      :live
    end

    def transaction_details
      @transaction_details
    end

    private

    def client
      @client ||= Faraday.new(CLIENT_URL) do |f|
        f.request :json
        f.headers['Content-Type'] = 'application/json'
        f.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      @transaction_details = JSON.parse(response.body)
    end
  end
end