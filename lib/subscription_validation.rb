class SubscriptionValidation
  def initialize(subscription)
    @subscription = subscription
  end

  def validate!
    validate_subscription_active
    validate_billing_period_paid
    validate_payment_attempt_limit
  end

  def valid?
    errors.empty?
  end

  def full_error_messages
    errors.join(', ')
  end

  private

  def validate_subscription_active
    add_error('Inactive subscription') unless subscription_active?
  end

  def validate_billing_period_paid
    add_error('Current billing period already paid') if current_billing_period_paid?
  end

  def validate_payment_attempt_limit
    add_error('Payment attempt limit exceeded') if payment_attempt_limit_exceeded?
  end

  def subscription_active?
    @subscription.active?
  end

  def current_billing_period_paid?
    current_billing_period.paid?
  end

  def payment_attempt_limit_exceeded?
    current_billing_period.transactions.insufficient_funds.count >= 4
  end

  def add_error(error)
    errors << error
  end

  def errors
    @errors ||= []
  end

  def current_billing_period
    @current_billing_period ||= @subscription.billing_periods.current
  end
end