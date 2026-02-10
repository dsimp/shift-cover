
begin
  ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: "db/development.sqlite3"
  )
  puts "Tables: #{ActiveRecord::Base.connection.tables.join(', ')}"
rescue => e
  puts "Error: #{e.message}"
end
