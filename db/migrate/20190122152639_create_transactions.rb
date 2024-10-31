class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.uuid       :token, default: "gen_random_uuid()", null: false              # Unique transaction token as UUID
      t.references :billing_period, foreign_key: true, type: :bigint, null: false # Foreign key to billing_periods table
      t.decimal    :amount, precision: 10, scale: 2, null: false                  # Transaction amount
      t.integer    :status, default: 0, null: false                               # Enum for transaction status

      t.timestamps
    end
  end
end