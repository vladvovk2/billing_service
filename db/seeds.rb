subscription = Subscription.create(
  plan: :basic,
  status: :active,
  amount: 9.99,
  next_billing_date: Date.today - 1.day,
  payment_method: :stripe
)

subscription.billing_periods.current
