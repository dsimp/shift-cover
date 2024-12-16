# == Schema Information
#
# Table name: quiz_questions
#
#  id                 :bigint           not null, primary key
#  question           :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  learning_module_id :bigint           not null
#
# Indexes
#
#  index_quiz_questions_on_learning_module_id  (learning_module_id)
#
# Foreign Keys
#
#  fk_rails_...  (learning_module_id => learning_modules.id)
#
# app/models/quiz_question.rb

class QuizQuestion < ApplicationRecord
  belongs_to :learning_module
  has_many :quiz_options, dependent: :destroy

  validates :question, presence: true
end

