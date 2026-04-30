class AddBusinessComplianceFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :ein, :string
    
    add_column :users, :agreed_to_client_services_agreement, :boolean, default: false
    add_column :users, :agreed_to_liability_waiver, :boolean, default: false
    add_column :users, :agreed_to_escrow_terms, :boolean, default: false
    add_column :users, :agreed_to_non_circumvention, :boolean, default: false
    add_column :users, :acknowledged_hazard_disclosure, :boolean, default: false
  end
end
