class NotSupportedPaymentGateway < StandardError; end

class PaymentGatewayFactory
  attr_reader :code

  def initialize(code)
    @code = code
  end

  def charge(subscription_id, amount)
    payment_gateway.charge(subscription_id, amount)
  end

  def name
    case payment_gateway.code
    when 'paypal' then 'PayPal'
    when 'stripe' then 'Stripe'
    else
      payment_gateway.code.capitalize
    end
  end

  def transaction_details
    payment_gateway.transaction_details
  end

  private

  def payment_gateway
    @payment_gateway ||= appropriate_payment_gateway
  end

  def appropriate_payment_gateway
    case @code
    when 'paypal'
      PaymentGateways::PayPal.new
    when 'stripe'
      PaymentGateways::Stripe.new
    else
      raise NotSupportedPaymentGateway, "Payment gateway with code #{@code} is not supported."
    end
  end
end
