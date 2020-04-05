# コミュニティー掲示板
http://3.115.206.168/

# 概要
・アカウント作成後、トピックの作成が可能になり、タイトルと本文を書き
込み、作成したトピックに画像と投票型のアンケートを 5 つまでつけること
ができます。
<br><br>
・作成されたトピックの詳細ページにて1つのトピックに対して1アカウントにつき一回だけアンケートに回答することができ、アンケートに投票後、集計結果が表示され、どのアンケートに何票投票されたのかがわかるようになります。
<br><br>
・1つのトピックに最大 100 件までコメントでのやり取りが可能で、
コメントにも画像を付けることができ、トピックやコメントに対して
評価(いいね機能)をつけることができます。

# 本番環境
url: http://3.115.206.168/
<br><br>
・サイトログイン<br>
ユーザー名: community_board<br>
パスワード: a61
<br><br>
・テストユーザーアカウント<br>
Eメール:t@t.com<br>
パスワード:password

# 制作背景(意図)

# DEMO

## フロント

- SASS, JQuery
- HTML

## バックエンド

- 画像アップロード・削除（Active Storage+Amazon S3）
- Rspec による自動テスト機能
- ユーザー登録・ログイン機能（deviseを使用）
- トピックの 投稿/削除/編集 機能
- いいね機能（Ajax）
- ページネーション機能（Kaminari）
- 検索機能（ransackでの複数検索）
- ユーザーデータ編集機能 /削除/編集機能


# 工夫したポイント

・トップページで投稿トピックの検索と並び替えが可能で、新着順や評価順
への並び替え、検索ワードやカテゴリーに絞ってトピックを探すことができます。
<br><br>
・トピックの編集・削除ページでログイン中のユーザーが投稿したトピックのみが一覧で表示され、そのページでトピックの編集ができ、トピックの横にチェックボックスがあり、チェックを付けたトピックをまとめて削除することができます。
<br><br>
・トップページとトピック詳細ページにページネーションを実装しているので、トップページではトピックの一覧が1ページにつき10件ずつ表示され、トピック詳細ページではコメントが1ページにつき50件ずつ表示され
るようにして処理の負担がかからないよう工夫しました。

# 使用技術

## 環境

- Ruby 2.5.1
- Rails 5.0.7.2
- MySQL 5.6.46
- Docker

## インフラ

- Nginx
- AWS (EC2, S3, Elastic IP)
- Capistrano

# DB設計

## Usersテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|
|image|string||
|email|string|null: false, unique: true|
|password|string|null: false|
|encrypted_password|string|null: false|

### Association
- has_many :topic          ,dependent: :destroy
- has_many :comment        ,dependent: :destroy
- has_many :vote           ,dependent: :destroy
- has_many :topic_likes    ,dependent: :destroy
- has_many :comment_likes  ,dependent: :destroy


## Topicsテーブル
|Column|Type|Options|
|------|----|-------|
|title|string|null: false|
|content|string|null: false|
|image|string||
|category_id|integer|null: false|
|user_id|integer|null: false, foreign_key: true|
|impressions_count|integer|default: 0|

### Association
- belongs_to_active_hash :category
- has_many :comments, dependent: :destroy
- has_many :enquetes, dependent: :destroy
- has_many :topic_likes, dependent: :destroy
- belongs_to :user


## Commentsテーブル
|Column|Type|Options|
|------|----|-------|
|content|string|null: false|
|image|string||
|topic_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :topic, dependent: :destroy
- belongs_to :user
- has_many :comment_likes, dependent: :destroy


## Enquetesテーブル
|Column|Type|Options|
|------|----|-------|
|content|string|null: false|
|topic_id"|integer|null: false, foreign_key: true|

### Association

- belongs_to :topic
- has_many :votes


## Votesテーブル
|Column|Type|Options|
|------|----|-------|
|enquete_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :enquete


## Topic_likesテーブル
|Column|Type|Options|
|------|----|-------|
|topic_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :topic


## Comment_likesテーブル
|Column|Type|Options|
|------|----|-------|
|comment_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :comment
