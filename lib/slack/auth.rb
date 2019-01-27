module Slack
  class Auth
    def self.slack_authorize_url(redirect_url)
      scope = 'identity.basic,identity.avatar'
      client_id = ENV['SLACK_CLIENT_ID']
      "https://slack.com/oauth/authorize?scope=#{scope}&client_id=#{client_id}&redirect_uri=#{redirect_url}"
    end

    def initialize(access_token)
      @access_token ||= access_token
    end

    def oauth_access(redirect_url, code)
      client.oauth_access(
          {
              client_id: ENV['SLACK_CLIENT_ID'],
              client_secret: ENV['SLACK_API_SECRET'],
              redirect_uri: redirect_url,
              code: code
          }
      )
    end

    def identity
      client.users_identity
    end

    def auth_revoke
      begin
        client.auth_revoke
      rescue Slack::Web::Api::Error => e
        Rails.logger.error e.message
      end
    end

    private

    def client
      @client ||= Slack::Web::Client.new(token: @access_token)
    end
  end
end