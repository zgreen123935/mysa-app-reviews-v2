require 'json'
require_relative '../lib/review_processor'
require_relative '../lib/app_store_client'

Handler = Proc.new do |req, res|
  begin
    # Initialize App Store client
    app_store = AppStoreClient.new(
      key_id: ENV['APP_STORE_KEY_ID'],
      issuer_id: ENV['APP_STORE_ISSUER_ID'],
      private_key: ENV['APP_STORE_PRIVATE_KEY'],
      bundle_id: ENV['APP_STORE_BUNDLE_ID']
    )

    # Fetch real App Store reviews
    reviews = {
      app_store: app_store.fetch_recent_reviews
    }

    # Initialize review processor
    processor = ReviewProcessor.new(
      ENV['SLACK_BOT_TOKEN'],
      ENV['SLACK_CHANNEL_ID']
    )

    # Process and post reviews
    result = processor.process_reviews(reviews)

    res.status = 200
    res.body = result.to_json
  rescue => e
    res.status = 500
    res.body = {
      error: e.message,
      backtrace: e.backtrace
    }.to_json
  end
end
