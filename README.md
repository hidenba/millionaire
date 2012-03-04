## millionaire
CSVを簡単に扱えるようになります。
読み込んだCSVデータに対してvalidationをかけることでデータの整合性を保証することができるようになります。
また、大量のCVデータの中から必要なデータだけを抽出することもできます。

現在はヘッダーのあるCSVしか読み込みはできないが、将来的にはヘッダーのないCSVにも対応する予定

# usage

## install
bundlerを使用している場合はGemfileにmillonaireを追加

```
gem 'millionaire'
```

## クラス定義
[name,address,phone,email]というフォーマットのCSVの場合

CSVヘッダのカラムと同一名称でカラムを定義することができるようになる

```
require 'millionaire'
class Smaple
  include Millionaire::Csv

  column :name
  column :address
  column :phone
  column :email
end
```

## CSVデータの読み込み
.loadメソッドにioオブジェクトを渡すことでCSVをロード

```
Sample.load(File.open file_path)
```

## レコードの検索

### .all すべてのレコードを取得

```
samples = Sample.all
samples.class.name   => Array
```

### .first 最初のレコードを取得

```
sample = Sample.first
```

### .last 最後のレコードを取得

```
sample = Sample.last
```

### .where カラムを対象に検索を行う

単一カラムを対象とした検索

```
samples = Sample.where(address: 'tokyo')
```

複数カラムを対象とした検索

```
samples = Sample.where(address: 'tokyo', name 'arice')
```

単一カラムで複数の値で検索

```
samples = Sample.where(address: ['tokyo','kyoto'])
```

## validation

カラム定義で宣言的にvalidationをかけることができる

### presence validator
必須項目の検証

```
column :name, pressence: true
```

### length validator
データの長さの検証

```
column :name, length: 20
```

### Inclution validator
配列で定義した内容の検証

```
column :name, value: %w(aice bob chrice)
```

### Integer Inclutioon
数値の場合に配列で定義した内容の検証

```
column :name, integer: true, value: 100..200
```

### constraint
ActiveModel::Validationsで定義されているvaridationを自由に記述できる

```
column :name, constraint: {format: {with: /\A[a-zA-Z]+\z/}}
```

### uniq(定義できるけど未実装)
単一カラムや複数カラムでの一意性を検証

```
column :name, uniq: [:adress]
```

### index
.whereで検索時に作成したインデックスを利用して検索を行うので、通常より高速な検索が可能となる。
複合インデックスの場合には、配列で定義をすることができるが、検索順序は定義した順でないとインデックスが効かないので
注意が必要

カラム定義でインデックスを設定

```
column :name, index: true
```

indexを宣言的に定義

```
index :name, [:name, :adress]
```

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