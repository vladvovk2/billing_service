class CreateBillingPeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_periods do |t|
      t.references :subscription, null: false, foreign_key: true                    # Foreign key to subscriptions table
      t.decimal    :amount_due,  precision: 10, scale: 2, default: 0.0, null: false # Amount due for the billing period
      t.decimal    :amount_paid, precision: 10, scale: 2, default: 0.0, null: false # Amount paid, default 0.0
      t.integer    :status, default: 0, null: false                                 # Payment status
      t.string     :billing_period, null: false                                             # End date for the billing period

      t.timestamps
    end

    add_index :billing_periods, %i[subscription_id billing_period], unique: true
  end
end