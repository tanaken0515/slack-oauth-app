module Slack
  class Auth
    def self.slack_authorize_url(redirect_url)
      scope = 'bot'
      client_id = ENV['SLACK_CLIENT_ID']
      "https://slack.com/oauth/authorize?scope=#{scope}&client_id=#{client_id}&redirect_uri=#{redirect_url}"
    end
  end
end