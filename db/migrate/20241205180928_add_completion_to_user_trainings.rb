class AddCompletionToUserTrainings < ActiveRecord::Migration[7.1]
  def change
    add_column :user_trainings, :completion, :boolean
  end
end
