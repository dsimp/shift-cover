class CreateQuizQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_questions do |t|
      t.references :learning_module, null: false, foreign_key: true
      t.text :question

      t.timestamps
    end
  end
end
