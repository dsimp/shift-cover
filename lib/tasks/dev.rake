require 'open-uri'

desc "Fill the database tables with some sample data"
task sample_data: :environment do
  if Rails.env.development?
    puts "Clearing existing data..."
    Job.destroy_all
    LearningModule.destroy_all
    QuizQuestion.destroy_all
    QuizOption.destroy_all
    UserJobType.destroy_all
    JobType.destroy_all
    User.destroy_all

    puts "Data cleared successfully."
  else
    puts "This task is intended for the development environment only."
    exit
  end

  # Define some sample job types
  job_type_titles = ["Cashier", "Valet", "Garage Attendant", "Package Handler", "Customer Service"]
  
  puts "Populating job_types table..."
  job_type_titles.each do |type|
    # Create the job type record
    jt = JobType.create!(title: type)
    puts "Created job type: #{jt.title}"

    # Generate description from OpenAI
    begin
      puts "Generating description for: #{jt.title}"
      jt.generate_description!
    rescue => e
      puts "Failed to generate description for #{type}: #{e.message}"
    end

    # Sleep to avoid hitting rate limits (adjust as necessary)
    sleep 5

    # Generate learning module from OpenAI
    begin
      puts "Generating learning module for: #{jt.title}"
      jt.generate_learning_module
    rescue => e
      puts "Failed to generate learning module for #{type}: #{e.message}"
    end

    sleep 5

    puts "Completed processing for: #{jt.title}"
  end

  puts "All job types have been successfully populated."
end
