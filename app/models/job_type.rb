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
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :training_module, presence: true, on: :update # Training module should be present after creation

  def generate_training_module
    # This is a placeholder for integration with the ChatGPT API
    # Use the OpenAI API to create a 15-minute training module and quiz
    OpenAI::Chat.new.call(
      model: "gpt-4",
      messages: [
        { role: "system", content: "You are a helpful assistant for job training content." },
        { role: "user", content: "Generate a 15-minute training module with a quiz for a #{title} job." }
      ]
    ).dig(:choices, 0, :message, :content)
  end
end
