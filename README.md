# README

SlackでログインするだけのWebアプリケーションを作ってみた。

### 環境構築
- dockerをインストールしておく
- このrepositoryをcloneする
- `docker-compose build`
- `docker-compose run --rm web bundle exec rails db:create`
  - DB使ってないけどこれをベースに発展させていくことを想定してDBを作っている
  - postgresqlを使ってる
- `docker-compose up`
- http://localhost:3000 にアクセス
  - ログイン画面が表示されたらOK

### 環境変数の設定
- 環境変数の管理にはgem `dotenv-rails` を使っている
- `.env.sample` をコピーして `.env` を作り、環境変数を設定する
- 環境変数を編集(追加,削除)した場合はサーバーを再起動したほうが良いかも
  - `docker-compose down`
  - `docker-compose up`

### Slackに関する環境変数
- https://api.slack.com/apps で Create New App 的なボタンを押す
- よしなに名前をつけてapplicationを作る
- `Basic Information` > `App Credentials` の下記2点をコピーして `.env` に貼り付ける
  - `Client ID`
  - `Client Secret`

ref: https://api.slack.com/docs/sign-in-with-slack