# Benjamin

Nature Remoのデータを取得してグラフ表示するアプリです。  
Ruby on Railsで開発しています。  
我が家におわす観葉植物から名付けました。

## 概要
1. `rails runner`でNature Remoから最新のデータを定期的に取得(5分おき等)。
2. 取得したデータをActive Record (DB)に追加。
3. Active RecordのデータをChartkickにてグラフ表示。

## 独自追加したファイル
1. データ取得用バッチ: `/lib/script/remo_api.rb`
2. バッチ定期実行スケジュール: `/config/schecule.rb` -> `wheneverize .`で追加
3. グラフ表示用View: `/app/views/monitor/*`

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

3. `schedule.rb`の内容をcronに登録する。
crontabへ展開する。
```bash
whenever --update-crontab
```

`crontab -l`を実行すると以下のような設定が追加されていることが確認できる。
```
0,5,10,15,20,25,30,35,40,45,50,55 * * * * /bin/bash -l -c 'cd <railsアプリのディレクトリ> && bundle exec bin/rails runner -e production '\''lib/script/remo_api.rb'\'''
```

※crontabから削除するには以下を実行する。
```bash
whenever --clear-crontab
```

4. 実行する。
```bash
rails server
```

## 参考
[Nature Remo Cloud API](https://developer.nature.global)
