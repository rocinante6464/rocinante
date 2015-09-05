# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Brain
==Rocinanteの思考プログラム
  Rocinanteは、自分が行うことを自ら考えます。
  急ぎの用事が無い場合は趣味を行います。
=end

module Rocinante
  # Brainクラス
  class Brain
    def initialize
      load ($root[:memory] + "memory.rb")
#      load ($mind_root + "mind.rb")

      $memory = Memory.new
#      $mind = Mind.new
    end

    def do_think(think_info)
      begin
        # 思考ファイル読み込む
        load $root[:think] + think_info[:file_name]

        # 思考結果を返却する
        think = Kernel.const_get(think_info[:think_id]).new

        return think.execute
      rescue => e
        # ログの出力を行います。
        puts think_info[:think_id] + "の実行に失敗しました。エラーメッセージ：" + e.message
        @log.error(think_info[:think_id] + "の実行に失敗しました。エラーメッセージ：" + e.message)

        return {
            error: true,
            think: nil
        }
      end
    end

    # 起きているか確認するメソッド
    def wakeup?
      return true
    end

    # 寝ていることを確認するメソッド
    def sleep?
      return false
    end

    # カーネルからの休憩命令があった場合に休止を行います。
    def do_rest
      puts self.class.name + "を休憩状態に以降します。"
    end
  end
end
