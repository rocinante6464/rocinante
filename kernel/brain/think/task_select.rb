# usr/bin/ruby
# coding:utf-8

=begin rdoc
=TaskSelect
==Rocinanteの思考プログラム（）
  ろしなんてのタスクを選択する際に使用される脳プログラムの一部です。
  タスク選択は現在直近の仕事がある場合それを行う。
  順位...
  1.優先度緊急のもの
  2.開始時間に達している仕事
  3.趣味、遊び
  1,2は依頼により生じるタスク。3は自ら考えるタスク
=end
module Rocinante
  # Brainクラス
  class TaskSelect
    def execute
      # 現在の時刻を取得
      time = Time.now

      # アクティブなタスクの個数を取得
      active_num = get_active_task

      # 多重度が３を超えている場合は新規タスクは行わない
      if( active_num > 3 ) then
        return {
          error: true,
          message: "並行して" + active_num.to_s + "個のタスクを行っているため、新しいタスクは行いません。"
        }
      end

      # 重要度０から順に実行タスクを検索しあったら決定
      # 重要度 0...緊急  1...仕事  2...趣味
      (0..2).each do |priority|
        task = get_task(time, priority)

        # ＳＱＬ実行失敗の場合はエラー
        if( task[:error] ) then
          raise self.class.name + " エラーメッセージ:" + task[:message]
        end

        # タスクがあった場合
        if( task[:data].length > 0 ) then
          puts "タスクを「" + task[:data][0]["ACTION_NAME"] + "」に決定しました！"

          return {
            error: false,
            think: task[:data][0],
            message: "タスクを「" + task[:data][0]["ACTION_NAME"] + "」に決定しました！"
          }
        end
      end

      # アクティブなタスクがあった場合新しいタスクを探しません。
      if( active_num >= 1 ) then
        return {
          error: true,
          think: nil,
          message: "忙しいので新しいタスクを行うのをやめました。"
        }
      end

      # 今やりたいことを選択し、テーブルに追加します。
      think_hobby(time)

      # タスクを取得します。
      task = get_task(time, 2)

      # ＳＱＬ実行失敗の場合はエラー
      if( task[:error] ) then
        raise self.class.name + " エラーメッセージ:" + result[:message]

      # もしデータが取得できた場合
      elsif( task[:data].length >= 1 ) then
        # 結果を返却
        return {
          error: false,
          think: task[:data][0],
          message: "タスクを「" + task[:data][0]["ACTION_NAME"] + "」に決定しました！"
        }
      end

      # 実行するべきタスクが無い場合エラー
      return {
        error: true,
        message: "選択するタスクがありません。"
      }
    end

    # 趣味を選択してタスクに登録
    def think_hobby(time)
      # 登録するタスクの情報を格納する変数
      task_columns = Hash.new
      # 現在有効な趣味を取得
      actions = get_hobbys(time)
      # アクションの個数を変数に格納
      max_num = actions.length

      # 乱数オブジェクトを生成
      random = Random.new
      # 選択値
      select_num = random.rand(max_num)

      # 選択したアクションのカラム情報を設定
      task_columns["ACTION_ID"] = actions[select_num]["ACTION_ID"]
      task_columns["PRIORITY"] = 2
      task_columns["TASK_STATE"] = 0

      # 各種日付の設定（limitは翌日の同じ時間を設定）
      task_columns[:start_date] = time.strftime($DATE_FORMAT)
      task_columns[:limit_date] = (time + (60 * 60 * 24)).strftime($DATE_FORMAT)
      task_columns[:update_date] = time.strftime($DATE_FORMAT)

      # タスクの登録
      result = $memory.insert("RC_TASK", task_columns)

      # もしエラーがあったらエラーを投げる
      if( result[:error] ) then
        raise self.class.name + " エラーメッセージ:" + result[:message]
      end
    end

    # アクションを取得します。
    def get_hobbys(time)
      # 現在有効な趣味を取得
      actions = get_actions(time, 2)

      # アクションが一個の場合はそのまま返却
      if( actions.length <= 1 ) then
        return actions
      end

      # 直前の趣味を取得
      bf_hobby = get_before_hobby

      # 次に実行する趣味がかぶらないように前回行った趣味は選択対象外にする。
      # 前回行ったタスクを選択肢から外す
      actions.delete_if do | action |
        action["ACTION_CLASS"] == bf_hobby["ACTION_CLASS"]
      end

      # 実行結果を返却する
      return actions
    end

    # アクションを取得します。
    def get_actions(time, type)
      sql = "SELECT * " +
            "FROM" +
            " RC_ACTION " +
            "WHERE" +
            " (ACTION_TYPE = ?)" +
            " AND (ACTIVE_FLG = 1)" +
            " AND (START_DATE <= ?)" +
            " AND (END_DATE > ?)"

      # SQLを実行
      strtime = time.strftime($DATE_FORMAT)
      # 結果を変数に格納
      result = $memory.execute(sql, [type.to_s, strtime, strtime])

      # エラーがあった場合処理中断
      if( result[:error] ) then
        raise self.class.name + " エラーメッセージ:" + result[:message]
      end

      # 実行結果を返却する
      return result[:data]
    end

    # １つ前の趣味を呼び出す
    def get_before_hobby
      sql = "SELECT" +
            " ACTION_CLASS " +
            "FROM" +
            " RC_TASK " +
            "WHERE" +
            " (PRIORITY = 2)" +
            " AND (TASK_STATE = 2) " +
            "ORDER BY UPDATE_DATE DESC " +
            "LIMIT 1"

      # 結果を変数に格納
      result = $memory.execute(sql, [])

      # エラーがあった場合処理中断
      if( result[:error] ) then
        raise self.class.name + " エラーメッセージ:" + result[:message]
      end

      # 実行結果を返却する
      return result[:data][0]
    end

    # アクティブ状態のタスクがあるか調べるメソッド
    def get_active_task
      sql = "SELECT COUNT(TASK_ID) " +
            "FROM" +
            " RC_TASK " +
            "WHERE" +
            " TASK_STATE = 1"

      # SQLを実行
      result = $memory.execute(sql, [])

      # エラーがあった場合
      if( result[:error] ) then
        raise self.class.name + " エラーメッセージ:" + result[:message]
      end

      # アクティブなタスクの個数を返す
      return result[:data][0][0]
    end

    def get_task(time, priority)
      sql = "SELECT" +
            " TASK_ID," +
            " ACTION_CLASS," +
            " ACTION_FILE," +
            " ACTION_NAME," +
            " SPAN_UNIT, " +
            " SPAN_VALUE " +
            "FROM RC_TASK_DETAIL " +
            "WHERE" +
            " (START_DATE <= ?) AND" +
            " (PRIORITY = ?) " +
            "ORDER BY LIMIT_DATE ASC " +
            "LIMIT 1"

      # paramsを設定
      params = Array.new
      params.push(time.strftime($DATE_FORMAT))
      params.push(priority.to_s)

      # ＳＱＬを実行
      return $memory.execute(sql, params)
    end
  end
end
