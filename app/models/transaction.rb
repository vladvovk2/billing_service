class Transaction < ActiveRecord::Base
  belongs_to :billing_period

  enum status: %i[pending success failed insufficient_funds aborted]
end
