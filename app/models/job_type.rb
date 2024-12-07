# == Schema Information
#
# Table name: job_types
#
#  id              :bigint           not null, primary key
#  description     :text
#  title           :string
#  training_module :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
  validates :description, presence: true

  def generate_learning_module
    return if learning_module.present?
  
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :api_key))
  
    # Generate training content
    content_response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "You are a helpful assistant for job training content." },
          { role: "user", content: "Generate a 15-minute training module with a quiz for a #{title} job." }
        ]
      }
    )
  
    training_content = content_response.dig("choices", 0, "message", "content")
  
    # Generate quiz content
    quiz_response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "You are an expert in creating quizzes." },
          { role: "user", content: "Create a 5-question multiple-choice quiz for the #{title} profession. Each question should have 4 options and a correct answer." }
        ]
      }
    )
  
    quiz_content = quiz_response.dig("choices", 0, "message", "content")
  
    # Save learning module
    LearningModule.create!(
      job_type: self,
      content: training_content,
      quiz: JSON.parse(quiz_content)
    )
  end
end
