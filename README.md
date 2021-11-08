# Benjamin (プロトタイプ - 開発中)

Nature Remoのデータを取得してグラフ表示するアプリです。  
Ruby on Railsで開発しています。  
我が家におわす観葉植物から名付けました。

## 概要
1. `rails runner`でNature Remoから最新のデータを定期的に取得。
2. 取得したデータをActive Record (DB)に追加。
3. Active RecordのデータをChartkickにてグラフ表示(1時間ごとの平均値)。

## 主要なファイル
1. データ取得用バッチ: `/lib/script/remo_api.rb`
2. グラフ表示用View: `/app/views/monitor/*`
3. グラフ表示用Controller: `/app/controller/monitor_controller.rb`

## 環境情報
* OS: Mac OS Monterey (12.0.1)
* Ruby: 3.0.2
* Rails: 6.1.4.1
* Yarn: 1.22.15
* SQLite: 3.36.0
* Whenever: v1.0.0
* Chartkick: 4.1.0
* Groupdate: 5.2.2

## 使い方
1. このソースを`clone`する。
```bash
git clone https://github.com/jirtosterone/Benjamin.git
```

2. Nature Remo Cloud APIを実行するためのCredentialファイルを用意する。  
`/lib/script/remo.json`
```json
{
  "remo": {
    "uri": "https://api.nature.global/1/devices",
    "auth": "Bearer <アクセストークン>",
    "accept": "application/json"
  }
}
```

3. `schedule.rb`を作成する。
```bash
# schedule.rbのスケルトンを作成
cd <railsアプリのディレクトリ>
wheneverize .
```

`/config/schedule.rb`
```ruby
# 環境設定
set :output, 'log/cron.log'
set :environment, :development
set :runner_command, 'rails runner'

# 5分おきにデータを取得
very 5.minute do
  runner "lib/script/remo_api.rb"
end
```

4. `schedule.rb`の内容をcronに登録する。
```bash
whenever --update-crontab
```

```bash
# cronの登録内容を確認
crontab -l
# 以下のような内容が登録されていればOK
# 0,5,10,15,20,25,30,35,40,45,50,55 * * * * /bin/bash -l -c 'cd <railsアプリのディレクトリ> && bundle exec rails runner -e development '\''lib/script/remo_api.rb'\'' >> log/cron.log 2>&1
```

```bash
# cronの登録内容を削除
whenever --clear-crontab
```

5. 実行する。
```bash
rails server
```

## 参考
[Nature Remo Cloud API](https://developer.nature.global)
