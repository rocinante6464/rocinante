# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Tweet
==RocinanteのAction

=end
require "twitter"
require "openssl"
require "yaml"

module TwitterClient
  # 引数のメッセージの内容でツイートを行います。
  def self.tweet(message)
    # 設定ファイルを読み込みます。
    config = YAML.load_file($etc_root + "twitter.yaml")

    # ツイッタークライアントのインスタンスを作成します。
    client = Twitter::REST::Client.new(config)

    # ツイートを行います。
    client.update(message)
  end
end
