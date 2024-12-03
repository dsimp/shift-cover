class RemoveLocationNameAndTitleFromJobs < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :location_name, :string
    remove_column :jobs, :title, :string
  end
end
