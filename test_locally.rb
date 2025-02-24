require 'dotenv'
require_relative 'lib/review_processor'

# Load environment variables from .env file
Dotenv.load

puts "🔍 Starting local test of review processing..."

begin
  # Initialize the processor with Slack credentials
  processor = ReviewProcessor.new(
    ENV['SLACK_BOT_TOKEN'],
    ENV['SLACK_CHANNEL_ID']
  )
  
  puts "📤 Processing and posting reviews..."
  results = processor.process_reviews
  
  puts "\n✅ Test completed successfully!"
  puts "📊 Results:"
  puts "- Reviews processed: #{results[:processed]}"
  puts "- Errors: #{results[:errors].length}"
  
  if results[:errors].any?
    puts "\n⚠️ Errors encountered:"
    results[:errors].each do |error|
      puts "- #{error}"
    end
  end
rescue => e
  puts "\n❌ Test failed!"
  puts "Error: #{e.message}"
  puts e.backtrace
end
