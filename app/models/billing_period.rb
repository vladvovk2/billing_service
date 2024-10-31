class BillingPeriod < ActiveRecord::Base
  has_many   :transactions
  belongs_to :subscription

  enum status: %i[pending partially_paid paid]

  scope :current, -> do
    begin
      find_or_create_by(billing_period: Date.today.strftime('%y_%m')) do |billing_period|
        billing_period.amount_due = billing_period.subscription.amount
      end
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end
