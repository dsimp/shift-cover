
require 'openai'

client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

begin
  response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "Hello, are you working?" }],
      max_tokens: 10
    }
  )
  puts "Response: #{response.dig("choices", 0, "message", "content")}"
rescue => e
  puts "Error: #{e.message}"
end
