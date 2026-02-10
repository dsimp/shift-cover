
begin
  puts "Checking Job model..."
  puts "Job count: #{Job.count}"
  puts "Destroying all jobs..."
  Job.destroy_all
  puts "Job count after destroy: #{Job.count}"
rescue => e
  puts "Error: #{e.class} - #{e.message}"
  puts e.backtrace
end
