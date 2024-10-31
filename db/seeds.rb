subscription = Subscription.create(
  plan: :basic,
  status: :active,
  amount: 9.99,
  next_billing_date: Date.today + 1.month,
  payment_method: :stripe
)
