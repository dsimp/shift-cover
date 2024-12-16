# == Schema Information
#
# Table name: quiz_options
#
#  id               :bigint           not null, primary key
#  correct          :boolean
#  option_text      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  quiz_question_id :bigint           not null
#
# Indexes
#
#  index_quiz_options_on_quiz_question_id  (quiz_question_id)
#
# Foreign Keys
#
#  fk_rails_...  (quiz_question_id => quiz_questions.id)
#
# app/models/quiz_option.rb

class QuizOption < ApplicationRecord
  belongs_to :quiz_question
  validates :option_text, presence: true
end

