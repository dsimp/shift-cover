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

    prompt = <<~PROMPT
      You are an expert corporate trainer designing an interactive, fun, and modern training module.
      Create an engaging, scenario-based training simulation for a new recruit assigned to the '#{title}' profession.
      
      Respond ONLY with a valid JSON object matching this exact structure:
      {
        "slides": [
          {
            "title": "A short, engaging title for the slide",
            "scenario": "A brief 1-2 sentence story setup or context.",
            "issue": "A specific problem, challenge, or customer situation that arises.",
            "solution": "The correct, professional way to handle the issue."
          }
        ],
        "quiz": [
          {
            "question": "A question directly related to the scenarios.",
            "options": ["Option A", "Option B", "Option C", "Option D"],
            "correct_answer": 0
          }
        ]
      }
      
      REQUIREMENTS:
      1. 'slides' MUST contain at least 5 distinct scenarios covering: Role Overview, Safety, Professionalism, Timeliness, and Customer Interaction. Make them realistic and fun to read.
      2. 'quiz' MUST contain EXACTLY 10 questions. Do not generate 9 or 11. Exactly 10.
      3. Every single quiz question MUST have its answer explicitly taught in the 'solution' section of the slides.
      4. Do not include markdown formatting like ```json in the output. Just raw JSON.
    PROMPT

    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "You are an expert AI simulator outputting valid JSON." },
            { role: "user", content: prompt }
          ]
        }
      )

      content = response.dig("choices", 0, "message", "content")
      content = content.gsub(/^```json/, '').gsub(/^```/, '').strip
      parsed_data = JSON.parse(content)

      # Save slides as a serialized JSON string in the 'content' field
      lm = LearningModule.create!(
        job_type: self,
        content: parsed_data["slides"].to_json,
        quiz: parsed_data["quiz"]
      )

      parsed_data["quiz"].each do |q|
        question = lm.quiz_questions.create!(question: q["question"])
        q["options"].each_with_index do |opt, i|
          question.quiz_options.create!(option_text: opt, correct: i == q["correct_answer"])
        end
      end
    rescue => e
      Rails.logger.error("Failed to generate learning module for #{title}: #{e.message}")
      puts "ERROR generating learning module for #{title}: #{e.message}"
    end
  end
end
