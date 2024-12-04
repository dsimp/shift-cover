class CreateUserTrainings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_trainings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :job_type, null: false, foreign_key: true
      t.datetime :completed_at

      t.timestamps
    end
  end
end
