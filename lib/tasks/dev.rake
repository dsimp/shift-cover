# lib/tasks/dev.rake
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
  end

  # Make sure you have a valid OpenAI API key and rate limit access
  # Also ensure `generate_description!` and `generate_learning_module`
  # methods in JobType are implemented and working.
  
  puts "Populating job_types table..."
  job_type_titles = ["Cashier", "Valet", "Garage Attendant", "Package Handler", "Customer Service"]
  
  job_type_titles.each do |type|
    jt = JobType.create!(title: type)
    
    # Generate description from OpenAI
    begin
      jt.generate_description!
    rescue => e
      puts "Failed to generate description for #{type}: #{e.message}"
    end

    # Sleep to avoid hitting rate limit
    sleep 5

    # Generate learning module from OpenAI
    begin
      jt.generate_learning_module
    rescue => e
      puts "Failed to generate learning module for #{type}: #{e.message}"
    end

    # Sleep again
    sleep 5

    puts "Create

