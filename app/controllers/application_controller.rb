class ApplicationController < ActionController::Base
  before_action :login_required

  private

  def session_effective?
    unless session[:access_token]
      reset_session
      return false
    end

    slack_api = Slack::Auth.new(session[:access_token])
    begin
      # 毎回APIリクエストを投げるのは多すぎる気がする。Rails.cacheに入れる？
      slack_api.auth_test
    rescue Slack::Web::Api::Error
      slack_api.auth_revoke
      reset_session
      return false
    end
    true
  end

  def login_required
    redirect_to login_path unless session_effective?
  end
end
