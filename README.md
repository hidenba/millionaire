## millionaire
CSVを簡単に扱えるようになります。
読み込んだCSVデータに対してvalidationをかけることでデータの整合性を保証することができるようになります。
また、大量のCVデータの中から必要なデータだけを抽出することもできます。
現在はヘッダーのあるCSVしか読み込みはできないが、将来的にはヘッダーのないCSVにも対応する予定

## usage
[read usage wiki page](https://github.com/hidenba/millionaire/wiki/Usage)

## 今後の実装予定

* belongs_to, has_many, has_one 等の関連の定義
** 一括ロードの仕組み?
* エンコーディングやセパレータの設定が出来る仕組み
* CSV出力
* uniq validator
* whereの連結
* whereで検索時に演算子を指定(:lt, glt...)
* READMEを英語化
* ヘッダのないCSV対応