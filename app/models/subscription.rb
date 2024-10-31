class Subscription < ActiveRecord::Base
  has_many :billing_periods

  enum status: %i[active paused canceled]
  enum plan:   %i[basic plus]
end
