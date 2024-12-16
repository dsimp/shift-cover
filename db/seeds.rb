# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

require 'openai'

JobType.destroy_all
LearningModule.destroy_all
QuizQuestion.destroy_all
QuizOption.destroy_all

job_type_titles = [
  "Cashier",
  "Valet",
  "Garage Attendant",
  "Package Handler",
  "Customer Service"
]

job_type_titles.each do |title|
  jt = JobType.find_or_create_by!(title: title)
  
  # Generate description with a delay
  jt.generate_description!
  sleep 5

  # Generate learning module with a delay
  jt.generate_learning_module
  sleep 5
end


puts "Seeded #{JobType.count} job types with generated descriptions and learning modules."
