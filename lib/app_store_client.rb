require 'jwt'
require 'net/http'
require 'json'
require 'time'
require 'base64'
require 'ecdsa'
require 'openssl'

class AppStoreClient
  APP_STORE_API_ENDPOINT = "https://api.appstoreconnect.apple.com/v1"

  def initialize(key_id:, issuer_id:, private_key:, bundle_id:)
    @key_id = key_id
    @issuer_id = issuer_id
    @private_key = private_key
    @bundle_id = bundle_id
  end

  def fetch_recent_reviews(since_time = nil)
    since_time ||= (Time.now - 86400) # Default to last 24 hours
    
    # First, get the app ID using the bundle ID
    app_id = get_app_id
    
    # Then fetch reviews for that app
    response = make_request("apps/#{app_id}/customerReviews")
    data = JSON.parse(response.body)
    
    return [] unless data["data"]

    data["data"].map do |review|
      attributes = review["attributes"]
      {
        id: review["id"],
        rating: attributes["rating"],
        title: attributes["title"],
        content: attributes["body"],
        author: attributes["reviewerNickname"] || "Anonymous",
        version: attributes["version"],
        created_at: attributes["createdDate"],
        platform: :app_store
      }
    end
  end

  private

  def get_app_id
    response = make_request("apps?filter[bundleId]=#{@bundle_id}")
    data = JSON.parse(response.body)
    
    raise "App not found for bundle ID: #{@bundle_id}" unless data["data"]&.first
    
    data["data"].first["id"]
  end

  def make_request(path)
    uri = URI("#{APP_STORE_API_ENDPOINT}/#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{generate_token}"
    
    response = http.request(request)
    
    unless response.code.to_i == 200
      raise "App Store API error: #{response.code} - #{response.body}"
    end
    
    response
  end

  def generate_token
    # Format private key for ES256
    key = format_private_key(@private_key)
    private_key = OpenSSL::PKey::EC.new(key)
    
    token = JWT.encode(
      {
        iss: @issuer_id,
        exp: Time.now.to_i + 300,  # 5 minute expiration
        aud: "appstoreconnect-v1"
      },
      private_key,
      "ES256",
      {
        kid: @key_id
      }
    )
    
    token
  end

  def format_private_key(key)
    # Add PEM markers if they don't exist
    unless key.include?("BEGIN PRIVATE KEY") || key.include?("BEGIN EC PRIVATE KEY")
      key = "-----BEGIN EC PRIVATE KEY-----\n#{key}\n-----END EC PRIVATE KEY-----\n"
    end
    key
  end
end
