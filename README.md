# Benjamin

Nature Remoのデータを取得してグラフ表示するアプリです。  
Ruby on Railsで開発しています。  
我が家におわす観葉植物から名付けました。

## 概要
1. `rails runner`でNature Remoから最新のデータを定期的に取得(5分おき等)。
2. 取得したデータをActive Record (DB)に追加。
3. Active RecordのデータをChartkickにてグラフ表示。

## 開発環境
* OS: Mac OS Monterey (12.0.1)
* Ruby: 3.0.2p107
* Rails: 6.1.4.1
* Yarn: 1.22.15
* SQLite: 3.36.0
* Chartkick: 4.1.0

## 実行環境
GitHubにアップして、Herokuにデプロイします。

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

## 参考
[Nature Remo Cloud API](https://developer.nature.global)
