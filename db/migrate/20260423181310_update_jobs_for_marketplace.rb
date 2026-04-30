class UpdateJobsForMarketplace < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :hourly_pay, :decimal, precision: 8, scale: 2
    add_column :jobs, :status, :integer, default: 0
    remove_column :jobs, :company_name, :string
    remove_column :jobs, :person_of_contact, :string
    remove_column :jobs, :phone_number, :string
  end
end
