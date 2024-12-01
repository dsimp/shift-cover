
require 'open-uri'

desc "Fill the database tables with some sample data"
task sample_data: :environment do
  if Rails.env.development?
    puts "Clearing existing data..."
    Job.destroy_all
    JobType.destroy_all
    User.destroy_all
  end

  puts "Populating users table..."

  12.times do
    name = Faker::Name.first_name
    user = User.create!(
      email: "#{name.downcase}@example.com",
      password: "password",
      name: name,
      location: "Chicago, IL"
    )

    # Attach a sample profile picture to the user
    begin
      # Use a placeholder image URL (e.g., via Lorem Picsum or RoboHash)
      avatar_url = "https://robohash.org/#{name.downcase}.png?size=300x300"

      # Open the image URL and attach it to the user
      downloaded_image = URI.open(avatar_url)
      user.profile_picture.attach(
        io: downloaded_image,
        filename: "#{name.downcase}_avatar.png",
        content_type: 'image/png'
      )
    rescue => e
      puts "Failed to attach image for user #{user.name}: #{e.message}"
    end

    puts "Created user: #{user.name}"
  end

  puts "Populating job_types table..."

  # Specify how many records to create
  number_of_job_types = 10

  number_of_job_types.times do
    JobType.create!(
      title: Faker::Job.title,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      training_module: Faker::Lorem.paragraph(sentence_count: 2)
    )
  end

  puts "#{number_of_job_types} job types created!"

  puts "Populating jobs table..."

  # Ensure there are users and job types to associate with
  if User.count < 2
    puts "Please create at least two users in the database before running this task."
    exit
  end

  if JobType.count.zero?
    puts "Please create some job types in the database before running this task."
    exit
  end

  # Specify how many records to create
  number_of_jobs = 10

  number_of_jobs.times do
    opener = User.order("RANDOM()").first
    cover = User.where.not(id: opener.id).order("RANDOM()").first
    job_type = JobType.order("RANDOM()").first

    Job.create!(
      shift_date: Faker::Date.between(from: 2.days.ago, to: 30.days.from_now),
      opener: opener,
      cover: cover,
      location_name: Faker::Company.name,
      shift_started_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
      shift_ended_at: Faker::Time.between(from: DateTime.now, to: DateTime.now + 1),
      location_address: Faker::Address.full_address,
      title: Faker::Job.title,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      job_type: job_type
    )
  end

  puts "#{number_of_jobs} jobs created!"

  puts "There are now #{User.count} users."
end
