class AddSubscriptionToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :subscription_tier, :integer, default: 0
    add_column :users, :subscription_expires_at, :datetime
  end
end
