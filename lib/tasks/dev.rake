require 'open-uri'
require 'faker'

desc "Fill the database tables with sample data using Faker"
task sample_data: :environment do
  # Ensure we are in the development environment
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
  job_type_titles = [
    "Cashier",
    "Valet",
    "Garage Attendant",
    "Package Handler",
    "Customer Service"
  ]

  puts "Populating job_types table..."
  job_type_titles.each do |type|
    jt = JobType.create!(title: type)
    puts "Created job type: #{jt.title}"

    # Attempt to generate description via OpenAI API
    begin
      puts "Generating description for: #{jt.title}"
      jt.generate_description! # Assumes this method interacts with OpenAI
    rescue => e
      puts "Failed to generate description for #{type}: #{e.message}"
    end

    sleep 5 # Adjust as needed to avoid rate limits

    # Attempt to generate learning module via OpenAI API
    begin
      puts "Generating learning module for: #{jt.title}"
      jt.generate_learning_module # Assumes this method interacts with OpenAI
    rescue => e
      puts "Failed to generate learning module for #{type}: #{e.message}"
    end

    sleep 5
    puts "Completed processing for: #{jt.title}"
  end

  # Create sample users with profile pictures
  puts "Creating sample users..."
  
  # We'll create 10 sample users with varied data
  users = 10.times.map do
    user = User.create!(
      name: Faker::Name.unique.name,
      email: Faker::Internet.unique.email,
      password: "password" # Devise virtual attribute
    )

    # Attach a random profile picture
    # Using https://picsum.photos for random images
    begin
      avatar_url = "https://picsum.photos/200"
      file = URI.open(avatar_url)
      user.profile_picture.attach(
        io: file, 
        filename: "avatar#{user.id}.jpg", 
        content_type: "image/jpg"
      )
    rescue => e
      puts "Failed to attach profile picture for #{user.email}: #{e.message}"
    end

    user
  end

  puts "Sample users created: #{User.count}"

  # Associate users with random subsets of job types
  puts "Associating users with job types..."
  all_job_types = JobType.all
  users.each do |user|
    # Randomly select between 1 and all available job types to give variety
    subset = all_job_types.sample(rand(1..all_job_types.count))
    subset.each do |jt|
      UserJobType.create!(user: user, job_type: jt)
    end
    puts "User #{user.email} associated with #{subset.count} job types."
  end
  puts "UserJobType associations created: #{UserJobType.count}"

  # Create some sample jobs
  # We'll create 15 jobs total, mixing them up for a realistic feel
  puts "Creating sample jobs..."

  all_users = User.all
  15.times do
    opener = all_users.sample # Random user as opener
    # Ensure opener has at least one job type associated
    opener_job_types = opener.job_types
    next if opener_job_types.empty?

    jt = opener_job_types.sample

    # Random shift date within the next 2 weeks (including some past dates to simulate history)
    shift_date = Date.today + rand(-2..14).days
    # Random start time between 6 AM and 11 AM
    shift_start = Time.current.change(hour: rand(6..11), min: [0, 15, 30, 45].sample) + (shift_date - Date.today).days
    # Shift end 4-9 hours later
    shift_end = shift_start + rand(4..9).hours

    # Generate a realistic phone number and company name
    phone = Faker::PhoneNumber.phone_number
    company = Faker::Company.name
    job_title = "#{jt.title} at #{company}"

    # Create the job
    Job.create!(
      title: job_title,
      company_name: company,
      description: Faker::Lorem.sentence(word_count: 10),
      job_type: jt,
      opener: opener,
      shift_date: shift_date,
      shift_started_at: shift_start,
      shift_ended_at: shift_end,
      location_address: Faker::Address.full_address,
      person_of_contact: Faker::Name.name,
      phone_number: phone
    )
  end

  puts "Sample jobs created: #{Job.count}"
  puts "Sample data generation complete!"
end

