require 'time'

module MockData
  class ReviewGenerator
    def self.generate_reviews
      current_time = Time.now
      {
        app_store: [
          {
            id: "1234567890",
            title: "Great app for home comfort",
            content: "Love how I can control my heating from anywhere. The schedules are really helpful.",
            rating: 5,
            author: "HappyUser123",
            version: "2.1.0",
            created_at: (current_time - 86400).strftime('%Y-%m-%dT%H:%M:%S%z')
          },
          {
            id: "1234567891",
            title: "Needs improvement",
            content: "App works well most of the time but sometimes loses connection.",
            rating: 3,
            author: "ThermostatPro",
            version: "2.1.0",
            created_at: current_time.strftime('%Y-%m-%dT%H:%M:%S%z')
          }
        ],
        google_play: [
          {
            id: "gp12345",
            title: "Very reliable",
            content: "Been using this for months now. Great for managing multiple thermostats.",
            rating: 4,
            author: "AndroidUser456",
            version: "2.0.9",
            created_at: (current_time - 172800).strftime('%Y-%m-%dT%H:%M:%S%z')
          },
          {
            id: "gp12346",
            title: "Energy savings!",
            content: "Helped reduce my heating bill significantly. Interface could be more intuitive though.",
            rating: 4,
            author: "EcoFriendly",
            version: "2.1.0",
            created_at: (current_time - 43200).strftime('%Y-%m-%dT%H:%M:%S%z')
          }
        ]
      }
    end
  end
end
