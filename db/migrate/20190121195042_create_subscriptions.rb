class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      # t.references :user, null: false, foreign_key: true        # Foreign key to users table
      t.integer    :plan, null: false, default: 0                 # Subscription plan, e.g., 'basic' or 'plus'
      t.integer    :status, null: false, default: 0               # Subscription status
      t.decimal    :amount, precision: 10, scale: 2, null: false  # Monthly subscription amount
      t.date       :next_billing_date, null: false                # Next billing date for the subscription
      t.string     :payment_method, null: false                   # Payment method, e.g., 'stripe', 'paypal' etc

      t.timestamps
    end
  end
end
