
# 1. Create Trainee User
puts "Creating Trainee User..."
begin
  # Skip sending welcome email to avoid AWS/Mailer errors in development
  User.skip_callback(:create, :after, :send_welcome_email)
  
  trainee = User.find_or_initialize_by(email: 'trainee@example.com')
  trainee.password = 'password'
  trainee.password_confirmation = 'password'
  trainee.name = 'New Trainee'
  trainee.location = 'Training Center'
  trainee.save!
  
  puts "  - Created/Found User: #{trainee.email}"
rescue => e
  puts "  - Error creating user: #{e.message}"
ensure
  User.set_callback(:create, :after, :send_welcome_email)
end


# 2. Update Job Descriptions
puts "\nUpdating Job Descriptions (removing 'mock' text)..."
JobType.find_each do |jt|
  puts "  - Processing: #{jt.title}"
  
  if jt.description.nil? || jt.description.include?("mock") || jt.description.length < 50
     puts "    - generating description..."
     begin
       jt.generate_description!
       puts "    - Success"
     rescue => e
       puts "    - Error: #{e.message}"
     end
     # Sleep to avoid rate limits
     sleep 2
  else
     puts "    - Description looks good, skipping."
  end
end

puts "\nDone! Login as trainee@example.com / password to test."
