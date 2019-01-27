class ApplicationController < ActionController::Base
  before_action :login_required

  private

  def session_effective?
    begin
      # 毎回APIリクエストを投げるのは多すぎる気がする。Rails.cacheに入れる？
      Slack::Auth.new(oauth_response[:access_token]).auth_test
    rescue Slack::Web::Api::Error
      # todo: tokenを無効化したほうがいいかも auth.revoke API
      reset_session
      return false
    end
    true
  end

  def login_required
    redirect_to login_path unless session_effective?
  end
end
