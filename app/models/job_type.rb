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
          { role: "system", content: "You are an expert corporate trainer." },
          {
            role: "user",
            content: "Generate a comprehensive, informational 5-10 minute reading/training module for the #{title} profession. \n\nCrucial Sections to Include:\n1. **Introduction & Role Overview**\n2. **Safety Procedures & Emergency Protocols** (Detailed)\n3. **Professionalism & Workplace Behavior** (Including code of conduct)\n4. **Timeliness & Consideration** (Punctuality and team respect)\n5. **Key Responsibilities & essential Skills**\n6. **Customer Interaction Guidelines**\n\nThe content must be specific to the #{title} role and serve as the study source for a challenging 15-question certification quiz."
          }
        ]
      }
    )

    training_content = content_response.dig("choices", 0, "message", "content")

    # Generate quiz content (15 multiple-choice questions)
    quiz_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are an expert in creating professional certification exams." },
          {
            role: "user",
            content: "Create a 15-question multiple-choice quiz for the #{title} profession as a JSON array. The questions should be slightly challenging and directly based on safety, professionalism, and role-specific duties. Each element: {question: string, options: [4 strings], correct_answer: int(0-3)}"
          }
        ]
      }
    )

    quiz_content = quiz_response.dig("choices", 0, "message", "content")
    
    # Clean up markdown code blocks if present
    quiz_content = quiz_content.gsub(/^```json/, '').gsub(/^```/, '').strip

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
