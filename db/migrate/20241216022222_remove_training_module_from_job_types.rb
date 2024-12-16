class RemoveTrainingModuleFromJobTypes < ActiveRecord::Migration[7.1]
  def change
    remove_column :job_types, :training_module, :text
  end
end
