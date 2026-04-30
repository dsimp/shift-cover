class AddStripeToUsersAndJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stripe_account_id, :string
    add_column :users, :stripe_customer_id, :string
    add_column :jobs, :payment_intent_id, :string
    add_column :jobs, :payout_status, :integer, default: 0
  end
end
