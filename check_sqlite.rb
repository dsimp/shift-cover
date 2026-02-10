
begin
  ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: "db/development.sqlite3"
  )
  puts "SQLite Users: #{User.count}"
  puts "SQLite Jobs: #{Job.count}"
  puts "SQLite JobTypes: #{JobType.count}"
rescue => e
  puts "Error: #{e.message}"
end
