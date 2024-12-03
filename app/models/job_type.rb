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

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :training_module, presence: true, on: :update

  def generate_training_module
    response = OpenAI::Chat.new.call(
      model: "gpt-4",
      messages: [
        { role: "system", content: "You are a helpful assistant for job training content." },
        { role: "user", content: "Generate a 15-minute training module with a quiz for a #{title} job." }
      ]
    )
    self.training_module = response.dig(:choices, 0, :message, :content)
    save
  end
end
