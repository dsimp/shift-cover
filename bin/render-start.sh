#!/usr/bin/env bash
# exit on error
set -o errexit

# Run migrations
bundle exec rake db:migrate

# Ruby on Rails
bundle exec rails server
