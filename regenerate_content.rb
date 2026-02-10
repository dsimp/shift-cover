
title = "Cashier"
jt = JobType.find_by(title: title)

if jt
  puts "Found JobType: #{title}"
  if jt.learning_module
    puts "Destroying old Learning Module..."
    jt.learning_module.destroy
    jt.reload
  end

  puts "Old module destroyed? #{jt.learning_module.nil?}"

  puts "Regenerating Learning Module (calling OpenAI)..."
  begin
    puts "Calling jt.generate_learning_module..."
    jt.generate_learning_module
    puts "Call returned."
    
    jt.reload
    lm = jt.learning_module
    if lm
      puts "Success!"
      puts "Content Length: #{lm.content.length} characters"
      puts "Preview:\n#{lm.content[0..500]}..."
    else
      puts "Failed: Learning Module is NIL after generation."
    end
  rescue => e
    puts "Error caught in script: #{e.class} - #{e.message}"
    puts e.backtrace
  end
else
  puts "JobType '#{title}' not found!"
end
