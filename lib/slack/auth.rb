module Slack
  class Auth
    def self.slack_authorize_url(redirect_url)
      scope = 'bot'
      client_id = ENV['SLACK_CLIENT_ID']
      "https://slack.com/oauth/authorize?scope=#{scope}&client_id=#{client_id}&redirect_uri=#{redirect_url}"
    end

    def self.oauth_access!(redirect_url, code)
      client = Slack::Web::Client.new
      client.oauth_access(
          {
              client_id: ENV['SLACK_CLIENT_ID'],
              client_secret: ENV['SLACK_API_SECRET'],
              redirect_uri: redirect_url,
              code: code
          }
      )
    end
  end
end