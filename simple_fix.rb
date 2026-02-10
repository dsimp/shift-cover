
puts "=== Starting Fix Script ==="

# 1. Create Trainee User
puts "1. Creating Trainee User..."
begin
  # Attempt to create user, ignoring mailer errors if they happen
  trainee = User.find_or_initialize_by(email: 'trainee@example.com')
  trainee.password = 'password'
  trainee.password_confirmation = 'password'
  trainee.name = 'New Trainee'
  trainee.location = 'Training Center'
  
  if trainee.save
    puts "   - SUCCESS: Created/Found User: #{trainee.email}"
  else
    puts "   - FAILURE: Validation errors: #{trainee.errors.full_messages.join(', ')}"
  end
rescue => e
  puts "   - CRITICAL ERROR creating user: #{e.message}"
  puts e.backtrace.first(5)
end

# 2. Update Job Descriptions
puts "\n2. Updating Job Descriptions..."
JobType.find_each do |jt|
  puts "   - Processing: #{jt.title}"
  
  if jt.description.nil? || jt.description.include?("mock") || jt.description.length < 50
     puts "     - Generating new description..."
     begin
       jt.generate_description!
       puts "     - Success"
     rescue => e
       puts "     - Error generating description: #{e.message}"
     end
     sleep 1 # Slight delay
  else
     puts "     - Description OK (length: #{jt.description&.length}), skipping."
  end
end

puts "\n=== Done ==="
