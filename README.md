## millionaire
CSVを簡単に扱えるようになります。
読み込んだCSVデータに対してvalidationをかけることでデータの整合性を保証することができるようになります。
また、大量のCVデータの中から必要なデータだけを抽出することもできます。

現在はヘッダーのあるCSVしか読み込みはできないが、将来的にはヘッダーのないCSVにも対応する予定

## usage

### install
bundlerを使用している場合はGemfileにmillonaireを追加

```
gem 'millionaire'
```

### クラス定義
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

### CSVデータの読み込み
.loadメソッドにioオブジェクトを渡すことでCSVをロード

```
Sample.load(File.open file_path )
```

### レコードの検索
.all すべてのレコードを取得

```
samples = Sample.all
samples.class.name   => Array
```

.first 最初のレコードを取得
```
sample = Sample.first
```

.last 最後のレコードを取得
```
sample = Sample.last
```

.where カラムを対象に検索を行う

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

### validation

### index
