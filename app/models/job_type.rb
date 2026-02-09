# == Schema Information
#
# Table name: job_types
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class JobType < ApplicationRecord
  has_many :user_job_types, dependent: :destroy
  has_many :users, through: :user_job_types
  has_many :user_trainings, dependent: :destroy
  has_many :trained_users, through: :user_trainings, source: :user
  has_many :jobs, dependent: :destroy
  has_one_attached :image
  has_one :learning_module, dependent: :destroy

  validates :title, presence: true, uniqueness: true

  # Generates a description if it's missing
  def generate_description!
    return if self.description.present?

    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :api_key) || ENV['OPENAI_API_KEY'])
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are an expert in professional job descriptions." },
          { role: "user", content: "Provide a concise yet detailed job description for a #{title} profession, focusing on primary responsibilities and key tasks." }
        ]
      }
    )

    generated_description = response.dig("choices", 0, "message", "content")
    update!(description: generated_description.strip)
  end

  def generate_learning_module
    return if learning_module.present?

    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :api_key) || ENV['OPENAI_API_KEY'])

    # Generate training content (~15 minutes)
    content_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are a helpful assistant for job training content." },
          {
            role: "user",
            content: "Generate a detailed training module (text only) for the #{title} profession. The module should be about 15 minutes in length when read at a normal pace. Include detailed explanations of daily responsibilities, essential skills, best practices, safety considerations, and any relevant protocols."
          }
        ]
      }
    )

    training_content = content_response.dig("choices", 0, "message", "content")

    # Generate quiz content (5 multiple-choice questions)
    quiz_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are an expert in creating quizzes." },
          {
            role: "user",
            content: "Create a 5-question multiple-choice quiz for the #{title} profession as a JSON array. Each element: {question: string, options: [4 strings], correct_answer: int(0-3)}"
          }
        ]
      }
    )

    quiz_content = quiz_response.dig("choices", 0, "message", "content")
    parsed_quiz = JSON.parse(quiz_content)

    lm = LearningModule.create!(
      job_type: self,
      content: training_content,
      quiz: parsed_quiz
    )

    parsed_quiz.each do |q|
      question = lm.quiz_questions.create!(question: q["question"])
      q["options"].each_with_index do |opt, i|
        question.quiz_options.create!(option_text: opt, correct: i == q["correct_answer"])
      end
    end
  end
end
