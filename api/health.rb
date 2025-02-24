require 'json'
require 'net/http'

Handler = Proc.new do |req, res|
  begin
    # Check if environment variables are set
    slack_token = ENV['SLACK_BOT_TOKEN']
    slack_channel = ENV['SLACK_CHANNEL_ID']

    # Test Slack API connection
    uri = URI('https://slack.com/api/auth.test')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{slack_token}"
    request['Content-Type'] = 'application/json'

    slack_response = http.request(request)
    slack_data = JSON.parse(slack_response.body)

    res.status = 200
    res.body = {
      status: 'ok',
      slack_configured: slack_data['ok'] == true,
      slack_token_present: !slack_token.nil? && !slack_token.empty?,
      slack_channel_present: !slack_channel.nil? && !slack_channel.empty?,
      slack_test_response: slack_data,
      env_dump: ENV.keys
    }.to_json
  rescue => e
    res.status = 500
    res.body = {
      error: e.message,
      error_class: e.class.name,
      backtrace: e.backtrace
    }.to_json
  end
end
