class AddPhoneNumberToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :phone_number, :string
  end
end
