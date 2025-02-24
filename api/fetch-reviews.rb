require 'json'
require_relative '../lib/review_processor'

Handler = Proc.new do |req, res|
  begin
    processor = ReviewProcessor.new(
      ENV['SLACK_BOT_TOKEN'],
      ENV['SLACK_CHANNEL_ID']
    )
    
    results = processor.process_reviews

    res.status = 200
    res.body = {
      message: 'Reviews successfully processed',
      processed: results[:processed],
      errors: results[:errors]
    }.to_json
  rescue => e
    res.status = 500
    res.body = { error: e.message }.to_json
  end
end
