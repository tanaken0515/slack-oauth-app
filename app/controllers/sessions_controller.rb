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
      response = Slack::Auth.oauth_access!(finish_auth_url, code)
    rescue Slack::Web::Api::Error => e
      message = "エラーが発生しました:#{e.message}"
      redirect_to login_url, notice: message
      return
    end

    workspace_code = response[:team_id]
    account_code = response[:authorizing_user][:user_id]
    access_token = response[:access_token]  # このtokenでリクエストが投げられるかを確認してもいいかもね
    user = User.upsert!(workspace_code, account_code, access_token)
    session[:user_id] = user.id  # todo: Userモデル
  end

  def destroy
    reset_session
    render :new
  end
end
