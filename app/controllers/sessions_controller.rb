class SessionsController < ApplicationController
  def new
  end

  def begin_auth
    # slackの認証画面にリダイレクトする todo: 環境変数を使う
    scope = 'aaa:bbbb,ccc:dddd'
    client_id = 'xxxxxxxxxx.xxxxxxxxx'
    uri = finish_auth_url
    redirect_to "https://slack.com/oauth/authorize?scope=#{scope}&client_id=#{client_id}&redirect_uri=#{uri}"
  end

  def finish_auth
    if params.include?(:error)
      message = (params[:error] == 'access_denied') ? 'キャンセルされました' : 'エラーが発生しました'
      render :new
    end

    code = params.fetch(:code, :not_found)
    client = Slack::Web::Client.new
    begin
      response = client.oauth_access(
          {
              client_id: 'xxxxxxxxxx.xxxxxxxxx',
              client_secret: '***************',
              redirect_uri: finish_auth_url,
              code: code
          }
      )
    rescue Slack::Web::Api::Error => e
      message = "エラーが発生しました:#{e}"
      render :new
    end

    workspace_code = response[:team_id]
    account_code = response[:authorizing_user][:user_id]
    access_token = response[:access_token]  # このtokenでリクエストが投げられるかを確認してもいいかもね
    user = User.upsert!(workspace_code, account_code, access_token)
    session[:user_id] = user.id  # todo: Userモデル
  end
end
