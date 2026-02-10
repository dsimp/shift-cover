
JobType.find_each do |jt|
  puts "\n========================================"
  puts "Processing: #{jt.title}"
  
  if jt.learning_module
    puts "  - Destroying existing module (Mock or Old)..."
    jt.learning_module.destroy
    jt.reload
  end

  puts "  - Generating new AI content..."
  begin
    jt.generate_learning_module
    jt.reload
    
    if jt.learning_module
      puts "  - SUCCESS! Module created."
      puts "  - Content Length: #{jt.learning_module.content.length} chars"
      puts "  - Quiz Questions: #{jt.learning_module.quiz_questions.count}"
    else
      puts "  - FAILURE: Module not created."
    end
  rescue => e
    puts "  - ERROR: #{e.message}"
  end
  
  # Sleep to avoid 429 Rate Limits
  puts "  - Sleeping 5 seconds..."
  sleep 5
end
