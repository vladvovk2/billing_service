class CalculateBillingAmount
  FRACTIONS = [1.0, 0.75, 0.5, 0.25].freeze

  def initialize(subscription)
    @billing_period = subscription.billing_periods.current
  end

  def amount
    if @billing_period.pending?
      calculate_pending_amount
    elsif @billing_period.partially_paid?
      calculate_partially_paid_amount
    end
  end

  def calculate_pending_amount
    @billing_period.amount_due * charge_fraction
  end

  def calculate_partially_paid_amount
    @billing_period.amount_due - @billing_period.amount_paid
  end

  def charge_fraction
    @charge_fraction ||= FRACTIONS[transactions_insufficient_funds_count]
  end

  def transactions_insufficient_funds_count
    @transactions_insufficient_funds_count ||= @billing_period.transactions.where(status: :insufficient_funds).count
  end
end
