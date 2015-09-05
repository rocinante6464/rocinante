# usr/bin/ruby
# coding:utf-8

=begin rdoc
=TweetHobby
==RocinanteのAction

=end

module Rocinante
  class TweetHobby < ActionBase
    # 現在のツイートテーブルからレコードを取得
    # ツイート率と今の気分を考慮してツイートを行うか判断
    # いろいろ考えよーか...
    def execute
      begin
        # ツイートを選択します。
        result = tweet_select

        # エラーがあった場合
        if( result[:error] ) then
          @action_info[:result_detail] = "ツイートは行いませんでした。"

        else
          # ツイートを行います。
          puts @message
          #TwitterClient::tweet(@message)

          # 実行結果を各種変数に格納
          @action_info[:result_detail] = "以下の内容でツイートを行いました。\n「" + @message + "」"
        end

        # 実行結果を各種変数に格納
        @action_info[:result] = 2

      rescue => e
        puts self.class.name + "でエラーが発生しました。エラーメッセージ:" + e.message
        @log.error(self.class.name + "でエラーが発生しました。エラーメッセージ:" + e.message)

        # 実行結果を各種変数に格納
        @action_info[:result] = -1
      end
    end

    # ツイートを選択します。
    def tweet_select

    end
  end
end
