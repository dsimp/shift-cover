namespace :learning_modules do
  desc "Generate learning modules for all job types"
  task generate: :environment do
    JobType.find_each do |job_type|
      job_type.generate_learning_module
      puts "Generated learning module for #{job_type.title}"
    end
  end
end
