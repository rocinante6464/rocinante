# usr/bin/ruby
# coding:utf-8

=begin rdoc
=ActionBase
==RocinanteのAction
  ろしなんての行動ベースクラス
=end

module Rocinante
  class ActionBase
    NOT_OVERRRIDE_EXECUTE = "NotOverRideError::execute"

    def initialize
      # ロガーを定義
      @log = Logger.new($root[:log] + "action.log")
      # レポート情報を格納する変数を初期化
      @action_info = Hash.new
      # 処理開始時間
      @action_info[:action_start_time] = Time.now
      # 実行結果（実行前だから結果セット無し）
      # 実行結果 0:未実行...1:実行中...2:正常終了...-1:異常終了
      @action_info[:result] = 0
      # 結果概要（初期値）
      @action_info[:result_detail] = "結果概要はありません。"
      # タスクを実行中状態にします。
      $memory.update("RC_TASK", {task_state: 1,update_date: Time.now.strftime($DATE_FORMAT)}, "TASK_ID = ?", [@action_info[:task_id]])
    end

    # レポートを書きます。
    def report
      # 処理終了時間
      @action_info[:action_end_time] = Time.now
      # 処理時間
      @action_info[:action_time] = (@action_info[:action_end_time] - @action_info[:action_start_time]).to_f

      # 開始時間・終了時間を文字列に変換する。
      @action_info[:action_start_time] = @action_info[:action_start_time].strftime($DATE_FORMAT)
      @action_info[:action_end_time] = @action_info[:action_end_time].strftime($DATE_FORMAT)

      # データの更新時間を挿入
      @action_info[:update_date] = Time.now.strftime($DATE_FORMAT)

      # タスクを実行完了状態にする
      $memory.update("RC_TASK", {task_state: 2,update_date: @action_info[:update_date]}, "TASK_ID = ?", [@action_info[:task_id]])

      # タスクレポートを出力
      $memory.insert("RC_TASK_REPORT", @action_info)
    end

    def execute
      raise NOT_OVERRRIDE_EXECUTE
    end

    def task_id=(task_id)
      # タスクＩＤ
      @action_info[:task_id] = task_id
    end

    def name=(name)
      # アクションの名前をセット
      @action_info[:action_name] = name
    end
  end
end
