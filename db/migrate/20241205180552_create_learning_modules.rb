class CreateLearningModules < ActiveRecord::Migration[7.1]
  def change
    create_table :learning_modules do |t|
      t.references :job_type, null: false, foreign_key: true
      t.text :content
      t.json :quiz

      t.timestamps
    end
  end
end
