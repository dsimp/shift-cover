class CreateJobTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :job_types do |t|
      t.string :title
      t.text :description
      t.text :training_module

      t.timestamps
    end
  end
end
