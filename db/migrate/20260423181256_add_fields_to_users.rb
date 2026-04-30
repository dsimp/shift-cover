class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :company_name, :string
    add_column :users, :person_of_contact, :string
    add_column :users, :phone_number, :string
  end
end
