class AddComplianceFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :ssn, :string
    
    add_column :users, :agreed_to_worker_agreement, :boolean, default: false
    add_column :users, :consented_to_background_check, :boolean, default: false
    add_column :users, :acknowledged_safety_training, :boolean, default: false
    add_column :users, :consented_to_privacy_policy, :boolean, default: false
    add_column :users, :consented_to_tos, :boolean, default: false
    
    add_column :users, :e_signature_timestamp, :datetime
  end
end
