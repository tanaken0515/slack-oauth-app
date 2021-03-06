class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :begin_auth, :finish_auth, :destroy]

  def new
  end

  def begin_auth
    redirect_to Slack::Auth.slack_authorize_url(finish_auth_url)
  end

  def finish_auth
    if params.include?(:error)
      message = (params[:error] == 'access_denied') ? 'キャンセルされました' : 'エラーが発生しました'
      redirect_to login_url, notice: message
      return
    end

    code = params.fetch(:code, :not_found)
    begin
      slack_api = Slack::Auth.new(nil)
      oauth_response = slack_api.oauth_access(finish_auth_url, code)
    rescue Slack::Web::Api::Error => e
      message = "エラーが発生しました:#{e.message}"
      redirect_to login_url, notice: message
      return
    end

    begin
      identity = Slack::Auth.new(oauth_response[:access_token]).identity
    rescue Slack::Web::Api::Error => e
      message = "エラーが発生しました:#{e.message}"
      redirect_to login_url, notice: message
      return
    end

    session[:access_token] = oauth_response[:access_token]
    session[:user] = identity[:user]
    redirect_to root_url, notice: 'ログインしました'
  end

  def show
    @slack_user_info = session[:user]
  end

  def destroy
    Slack::Auth.new(session[:access_token]).auth_revoke
    reset_session
    redirect_to login_url, notice: 'ログアウトしました'
  end
end
