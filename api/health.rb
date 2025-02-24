Handler = Proc.new do |req, res|
  begin
    slack_configured = !ENV['SLACK_BOT_TOKEN'].nil? && !ENV['SLACK_BOT_TOKEN'].empty? &&
                      !ENV['SLACK_CHANNEL_ID'].nil? && !ENV['SLACK_CHANNEL_ID'].empty?

    res.status = 200
    res.body = {
      status: 'ok',
      slack_configured: slack_configured
    }.to_json
  rescue => e
    res.status = 500
    res.body = { error: e.message }.to_json
  end
end
