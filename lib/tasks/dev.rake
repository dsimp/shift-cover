require 'open-uri'

desc "Fill the database tables with some sample data"
task sample_data: :environment do
  if Rails.env.development?
    puts "Clearing existing data..."
    Job.destroy_all
    JobType.destroy_all
    User.destroy_all
  end

  puts "Populating job_types table..."
  job_types = %w[Cashier Valet Garage\ Attendant Package\ Handler Customer\ Service]
  job_types.each do |type|
    JobType.create!(title: type, description: Faker::Lorem.sentence, training_module: Faker::Lorem.paragraph)
    puts "Created JobType: #{type}"
  end

  puts "Populating users table..."
  12.times do
    name = Faker::Name.first_name
    user = User.create!(
      email: "#{name.downcase}@example.com",
      password: "password",
      name: name,
      location: Faker::Address.city
    )
    # Attach a sample profile picture
    begin
      avatar_url = "https://robohash.org/#{name.downcase}.png?size=300x300"
      downloaded_image = URI.open(avatar_url)
      user.profile_picture.attach(
        io: downloaded_image,
        filename: "#{name.downcase}_avatar.png",
        content_type: 'image/png'
      )
    rescue => e
      puts "Failed to attach image for user #{user.name}: #{e.message}"
    end

    # Assign random professions
    professions = JobType.order('RANDOM()').limit(rand(1..3))
    professions.each do |job_type|
      UserJobType.create!(user: user, job_type: job_type)
    end
    puts "Created user: #{user.name} with professions: #{professions.map(&:title).join(', ')}"
  end

  puts "Populating jobs table..."
  10.times do
    opener = User.order('RANDOM()').first
    job_type = JobType.order('RANDOM()').first
    Job.create!(
      shift_date: Faker::Date.between(from: 2.days.ago, to: 30.days.from_now),
      shift_started_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
      shift_ended_at: Faker::Time.between(from: DateTime.now, to: DateTime.now + 1),
      location_address: Faker::Address.full_address,
      description: Faker::Lorem.paragraph,
      company_name: Faker::Company.name,
      person_of_contact: Faker::Name.name,
      phone_number: Faker::PhoneNumber.phone_number,
      job_type: job_type,
      opener: opener
    )
  end

  puts "Sample data generation completed!"
end
