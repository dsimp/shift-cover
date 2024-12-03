class AddCompanyNameAndPersonOfContactToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :company_name, :string
    add_column :jobs, :person_of_contact, :string
  end
end
