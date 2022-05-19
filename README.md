# :large_orange_diamond:コミュニティー掲示板:large_orange_diamond:

# 概要
・アカウント作成後、トピックとコメントの投稿とアンケートの回答が可能になり、投稿ページでトピック名と本文を書き込み、任意で画像と投票型のアンケートを5つまで作成することができます。
  
・作成されたトピックの詳細ページにて、1つのトピックに対して1アカウントにつき一回だけアンケートに回答することができ、アンケートに投票後、集計結果が表示され、どのアンケートに何票投票されたのかがわかるようになります。
  
・1つのトピックに最大 100 件までコメントでのやり取りが可能で、
コメントにも画像を付けることができ、トピックやコメントに対して
評価（いいね機能）をつけることができます。

# 本番環境
URL: 3.113.2.203/

・テストユーザーアカウント  
Eメール:t@t.com  
パスワード:aaaaaaaa

# 制作背景（意図）
情報共有の場として交流できるサービスを提供したいという思いで作成した掲示板アプリです。さまざまな掲示板サイトを参考にして作成し、画像投稿や評価機能、アンケート機能を掲示板に盛り込んでトピックの話題を盛り上げられるように工夫して掲示板サイトとして充実性を持たせました。


# DEMO

## トップ画面
<img width="1440" alt="スクリーンショット 2020-04-03 19 10 57" src="https://user-images.githubusercontent.com/54573782/78485205-d1a59e00-7781-11ea-81c9-d914186837de.png">


## フロント

- SASS, JQuery
- HTML

## バックエンド

- 画像アップロード・削除（carrierwave + fog-aws）
- Rspec による自動テスト機能
- ユーザー登録・ログイン機能（deviseを使用）
- トピックの 投稿/削除/編集 機能
- いいね機能（Ajax）
- ページネーション機能（Kaminari）
- 検索機能（ransackでの複数検索）
- ユーザーデータ編集機能 /削除/編集機能


# 工夫したポイント

・トップページで投稿トピックの検索と並び替えが可能で、新着順や評価順
への並び替え、検索ワードやカテゴリーに絞ってトピックを探すことができるようにしました。

・トピックの編集・削除ページでログイン中のユーザーが投稿したトピックのみが一覧で表示され、そのページでトピックの編集と削除の両方が可能で、表示されているトピックの横にチェックボックスがあり、チェックを付けたトピックのみをまとめて削除することができるようにしました。

・トピック詳細ページでトピックとコメントに画像をつけていると投稿した箇所に画像ボタンが出現し、ボタンを押すと投稿した画像の拡大写真が表示されるようにしたので、画像でページが圧迫されないように工夫しました。

・トップページとトピック詳細ページにページネーションを実装しているので、トップページではトピックの一覧が1ページにつき10件ずつ表示され、トピック詳細ページではコメントが1ページにつき50件ずつ表示されるようにして表示による処理の負担が軽減されるよう工夫しました。

# 使用技術

## 環境

- Ruby 2.5.1
- Rails 5.0.7.2
- MySQL 5.6.46
- Docker

## インフラ

- Nginx
- AWS (EC2, RDS for MySQL, S3, Route53, Elastic IP)
- Capistrano


# 今後の目標・予定
- Vue.jsを学習してアプリっぽい雰囲気になるようにクオリティーを充実させる
- これを元にニュースアプリやショッピングサイトなどサービス志向の作成に挑戦してグロースさせられるようにする


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
|topic_id|integer|null: false, foreign_key: true|

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
