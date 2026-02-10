#!/usr/bin/env bash
# exit on error
set -o errexit

# Wait for database connection
echo "Checking database connection..."
bundle exec ruby -e "
  require 'pg'
  require 'uri'
  
  # Ensure stdout is flushed immediately
  STDOUT.sync = true
  
  url = ENV['DATABASE_URL']
  if url.nil? || url.empty?
    puts 'DATABASE_URL not set, skipping connection check.'
    exit 0
  end

  uri = URI.parse(url)
  retries = 0
  max_retries = 30 # Wait up to 60 seconds

  begin
    PG.connect(
      host: uri.host,
      port: uri.port,
      user: uri.user,
      password: uri.password,
      dbname: uri.path[1..-1],
      sslmode: 'prefer'
    )
    puts 'Database connected successfully!'
  rescue PG::Error => e
    puts \"Waiting for database... (#{e.message})\"
    retries += 1
    if retries <= max_retries
      sleep 2
      retry
    else
      puts 'Could not connect to database after multiple attempts.'
      exit 1
    end
  end
"

# Run migrations
bundle exec rake db:migrate

# Ruby on Rails
bundle exec rails server
