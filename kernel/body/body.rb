# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Body
==Rocinanteの行動プログラム
  Rocinanteは、脳からの命令を受け取って行動します。
  Bodyクラスは受け取った命令と同名のクラスを実行します。
=end

module Rocinante
  # Bodyクラス
  class Body
    def initialize
      @log = Logger.new($root[:log] + "kernel.log")
    end

    # アクションを実行します。
    def do_action(task_info)
      begin
        # アクションファイルを読み込む
        load $root[:action] + task_info["ACTION_FILE"]

        # 引数に与えられたアクションのインスタンスを生成します。
        @action_class = Kernel.const_get("Rocinante::" + task_info["ACTION_CLASS"]).new
        # タスクＩＤをセット
        @action_class.task_id = task_info["TASK_ID"]
        # アクション名をセット
        @action_class.name = task_info["ACTION_NAME"]
        # アクションを実行します。
        @action_class.execute
        # アクションのレポートを出力します。
        @action_class.report

        return true

      rescue => e
        # ログの出力を行います。
        puts task_info["ACTION_CLASS"] + "の実行に失敗しました。エラーメッセージ：" + e.message
        @log.error(task_info["ACTION_CLASS"] + "の実行に失敗しました。エラーメッセージ：" + e.message)

        return false
      end
    end

    def do_rest
      puts self.class.name + "を休憩状態に以降します。"
    end
  end
end
