class SessionsController < ApplicationController
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
      slack_api = Slack::Auth.new(oauth_response[:access_token])
      slack_api.auth_test
    rescue Slack::Web::Api::Error => e
      message = "エラーが発生しました:#{e.message}"
      redirect_to login_url, notice: message
      return
    end

    session[:access_token] = response[:access_token]
    redirect_to login_url, notice: 'ログインしました' # todo: ログインしないと見れない系の画面にリダイレクトする
  end

  def destroy
    reset_session
    render :new
  end
end
