class AddTitleToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :title, :string
  end
end
