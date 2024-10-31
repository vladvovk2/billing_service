# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2019_01_22_152639) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_periods", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.decimal "amount_due", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "amount_paid", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.string "billing_period", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id", "billing_period"], name: "index_billing_periods_on_subscription_id_and_billing_period", unique: true
    t.index ["subscription_id"], name: "index_billing_periods_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "plan", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.date "next_billing_date", null: false
    t.string "payment_method", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.uuid "token", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "billing_period_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_period_id"], name: "index_transactions_on_billing_period_id"
  end

  add_foreign_key "billing_periods", "subscriptions"
  add_foreign_key "transactions", "billing_periods"
end
