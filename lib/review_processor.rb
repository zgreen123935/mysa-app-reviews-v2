require 'json'
require 'net/http'

class ReviewProcessor
  class SlackError < StandardError; end

  def initialize(slack_token, slack_channel)
    if slack_token.nil? || slack_token.empty?
      raise SlackError, "Slack token is missing"
    end
    
    if slack_channel.nil? || slack_channel.empty?
      raise SlackError, "Slack channel ID is missing"
    end

    @slack_token = slack_token
    @slack_channel = slack_channel
  end

  def process_reviews(reviews)
    results = {
      processed: 0,
      errors: [],
      debug_info: {
        slack_token_length: @slack_token&.length,
        channel_id_length: @slack_channel&.length,
        review_count: reviews.values.flatten.length
      }
    }

    reviews.each do |platform, platform_reviews|
      platform_reviews.each do |review|
        begin
          response = post_to_slack(format_review(platform, review))
          slack_data = JSON.parse(response.body)
          
          if slack_data['ok']
            results[:processed] += 1
          else
            results[:errors] << {
              type: 'slack_error',
              message: slack_data['error'],
              review: review[:id]
            }
          end
        rescue => e
          results[:errors] << {
            type: 'processing_error',
            message: e.message,
            review: review[:id],
            backtrace: e.backtrace
          }
        end
      end
    end

    results
  end

  private

  def format_review(platform, review)
    blocks = [
      {
        type: "header",
        text: {
          type: "plain_text",
          text: "#{platform_icon(platform)} New Review from #{platform_name(platform)}",
          emoji: true
        }
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: "*Rating:*\n#{stars(review[:rating])}"
          },
          {
            type: "mrkdwn",
            text: "*Version:*\n#{review[:version]}"
          }
        ]
      },
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "*#{review[:title]}*\n#{review[:content]}"
        }
      },
      {
        type: "context",
        elements: [
          {
            type: "mrkdwn",
            text: "Posted by *#{review[:author]}* on #{format_date(review[:created_at])}"
          }
        ]
      },
      {
        type: "divider"
      }
    ]

    {
      channel: @slack_channel,
      blocks: blocks
    }
  end

  def platform_icon(platform)
    platform == :app_store ? "🍎" : "🤖"
  end

  def platform_name(platform)
    platform.to_s.split('_').map(&:capitalize).join(' ')
  end

  def stars(rating)
    "⭐" * rating
  end

  def format_date(date_str)
    Time.parse(date_str).strftime("%B %d, %Y at %I:%M %p")
  end

  def post_to_slack(message)
    uri = URI('https://slack.com/api/chat.postMessage')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{@slack_token}"
    request['Content-Type'] = 'application/json'
    request.body = message.to_json

    begin
      response = http.request(request)
      puts "Slack API Response: #{response.code} - #{response.body}"
      response
    rescue => e
      raise SlackError, "Failed to post to Slack: #{e.message}"
    end
  end
end
