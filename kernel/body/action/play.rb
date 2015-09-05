# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Play
==RocinanteのAction

=end

# Playクラス
module Rocinante
  class Play < ActionBase
    def execute
      puts "ろしなんては遊んでいます。"

      # 実行結果を各種変数に格納
      @action_info[:result] = 2
      @action_info[:result_detail] = "ろしなんては遊び終わりました。"
    end
  end
end
