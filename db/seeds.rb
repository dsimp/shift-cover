# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'openai'

puts "Starting seed process..."

def safe_destroy(model)
  puts "Destroying #{model}..."
  model.destroy_all
  puts "  Done."
rescue => e
  puts "  Failed to destroy #{model}: #{e.message}"
end

puts "Cleaning up existing data..."
  # safe_destroy(Job)
  # safe_destroy(UserTraining)
safe_destroy(UserJobType)
safe_destroy(User)
safe_destroy(QuizOption)
safe_destroy(QuizQuestion)
safe_destroy(LearningModule)
safe_destroy(JobType)

puts "Creating Users..."
begin
  opener = User.find_or_create_by!(email: 'opener@example.com') do |u|
    u.password = 'password'
    u.password_confirmation = 'password'
    u.name = 'Shift Opener'
    u.location = 'Downtown Store'
  end
  puts "  Created/Found opener."

  cover = User.find_or_create_by!(email: 'cover@example.com') do |u|
    u.password = 'password'
    u.password_confirmation = 'password'
    u.name = 'Shift Cover'
    u.location = 'Uptown Branch'
  end
  puts "  Created/Found cover."
rescue => e
  puts "Error creating/finding users: #{e.message}"
  exit 1
end

job_type_titles = [
  "Cashier",
  "Valet",
  "Garage Attendant",
  "Package Handler",
  "Customer Service"
]

puts "Creating Job Types and Generating AI Content..."
job_type_titles.each do |title|
  puts "  Processing: #{title}"
  
  begin
    jt = JobType.create!(title: title)
    
    # Generate AI Content
    begin
      print "    Generating description... "
      jt.generate_description!
      puts "Done."
      sleep 5
      
      print "    Generating learning module & quiz... "
      jt.generate_learning_module
      puts "Done."
      sleep 5
    rescue => e
      puts "    ERROR generating AI content: #{e.message}"
      puts "    Falling back to MOCK content..."
      
      # Mock Description
      jt.update!(description: "This is a mock description for #{title}. The AI service was unavailable, so this placeholder text was generated to ensure the system functions correctly.")
      
      # Mock Learning Module & Quiz
      unless jt.learning_module.present?
        # Create 3 Mock Questions
        questions = [
          { "question" => "What is the most important rule?", "correct_answer" => 1, "options" => ["Speed", "Safety first", "Lunch", "Fun"] },
          { "question" => "How should you greet customers?", "correct_answer" => 2, "options" => ["Rudely", "Silently", "Politely", "With a dance"] },
          { "question" => "What should you follow?", "correct_answer" => 1, "options" => ["Dreams", "Procedures", "Nothing", "The wind"] }
        ]

        lm = LearningModule.create!(
          job_type: jt,
          content: "This is a MOCK training module for #{title}. \n\n1. Always be polite.\n2. Safety first.\n3. Follow procedures.",
          quiz: questions
        )
        
        questions.each do |q_data|
          q = lm.quiz_questions.create!(question: q_data["question"])
          q_data["options"].each_with_index do |opt, i|
            q.quiz_options.create!(option_text: opt, correct: i == q_data["correct_answer"])
          end
        end
        puts "    Created MOCK learning module with #{questions.size} questions."
      end
    end
    
    # Create Associations
    UserJobType.create!(user: opener, job_type: jt)
    UserJobType.create!(user: cover, job_type: jt)

    # Create Open Jobs (Future)
    Job.create!(
      job_type: jt,
      opener: opener,
      shift_date: Date.tomorrow,
      shift_started_at: Time.current.tomorrow.change(hour: 9),
      shift_ended_at: Time.current.tomorrow.change(hour: 17),
      location_address: "123 Main St, #{opener.location}",
      description: "Need coverage for #{title} shift. Standard duties.",
      company_name: "Shift Co.",
      person_of_contact: "Manager Mike",
      phone_number: "555-0123",
      title: "#{title} Shift (Open)"
    )

    # Create Covered Jobs (History)
    Job.create!(
      job_type: jt,
      opener: opener,
      cover: cover,
      shift_date: Date.yesterday,
      shift_started_at: 1.day.ago.change(hour: 9),
      shift_ended_at: 1.day.ago.change(hour: 17),
      location_address: "456 Oak St, #{cover.location}",
      description: "Past #{title} shift.",
      company_name: "Shift Co.",
      person_of_contact: "Supervisor Sarah",
      phone_number: "555-0987",
      title: "#{title} Shift (Covered)"
    )

    # Simulate Training Completion for 'cover' user
    UserTraining.create!(
      user: cover,
      job_type: jt,
      completion: true,
      completed_at: Time.current
    )
  rescue => e
    puts "Error processing #{title}: #{e.message}"
    puts e.backtrace.first(5)
  end
end

puts "Seeding complete!"
puts "Users: #{User.count}"
puts "Jobs: #{Job.count}"
puts "JobTypes: #{JobType.count}"
puts "LearningModules: #{LearningModule.count}"
