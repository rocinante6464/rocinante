# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Memory
==Rocinanteの記憶プログラム
  Rocinanteは、前に行った行動を記憶できます。
  記憶すること、記憶から呼び出すことを管理します。
  つまり、ＤＡＯです！！

  メソッドリスト
  *insert  データの挿入用メソッド
  *update  データの更新用メソッド
  *delete  データの削除用メソッド
  *select  データの参照用メソッド
  *execute SQLの実行用メソッド
=end

module Rocinante

  # Memoryクラス
  class Memory
    def initialize
      @db = SQLite3::Database.new($memory_root + "rocinante.db")
      @db.results_as_hash = true

      @log = Logger.new($log_root + "kernel.log")
    end

    # インサートメソッド
    def insert(table_name, fields)
      # カラム情報、入れる値の情報を格納する変数
      columns = Array.new
      values  = Array.new
      params  = Array.new

      # ハッシュテーブルからカラム情報、値の情報を抽出
      for field in fields
        # ＳＱＬを作成する
        columns.push(field[0].to_s)
        values.push("?")

        # バインドする値を配列に格納する
        params.push(field[1].to_s)
      end

      # SQL文を生成する
      sql = "INSERT INTO " + table_name + " ("
      sql += columns.join(",")
      sql += ") VALUES ("
      sql += values.join(",")
      sql += ");"

      # executeメソッドを実行する
      return execute(sql, params)
    end

    # アップデートメソッド
    def update(table_name, fields, where, where_params)
      # 入れる値の情報を格納する変数
      params  = Array.new

      # SQL文を生成する
      sql =   "UPDATE " + table_name
      sql += " SET "

      # ハッシュテーブルからカラム情報、値の情報を抽出
      for field in fields
        # ＳＱＬを作成する
        sql += field[0].to_s + " = ?,"
        # バインドする値を配列に格納する
        params.push(field[1].to_s)
      end

      # 最後のカンマを取り除く
      sql.chop!

      # WHERE文を結合
      sql += " WHERE " + where
      params.concat(where_params)

      # executeメソッドを実行する
      return execute(sql, params)
    end

    # デリートメソッド
    def delete(table_name, where, params)
      sql =  "DELETE"
      sql += " FROM" + table_name
      sql += " WHERE " + where

      # executeメソッドを実行する
      return execute(sql, params)
    end

    # SQLの実行メソッド
    def execute(sql, params)
      db_result = Array.new
      tmp_result = Array.new

      begin
        # トランザクションを開始します
        @db.transaction do

          if( params.length == 0  ) then
            tmp_result = @db.execute(sql)
          else
            # プリペアドステートメントを設定します
            stmt = @db.prepare(sql)

            # バインド変数の設定してインサートを行います
            tmp_result = stmt.execute(params)
          end
        end

        # データを整形して配列にする
        tmp_result.each do |row|
          db_result.push(row)
        end

        # SQL成功
        result = {
          data: db_result,
          error: false,
          message: "SQLの実行に成功しました！",
          sql: sql,
          params: params.join(",")
        }
      rescue => e
        # SQL失敗
        result = {
          data: db_result,
          error: true,
          message: "SQLの実行に失敗しました。エラーメッセージ：" + e.message,
          sql: sql,
          params: params.join(",")
        }
      ensure
        # SQLの実行ログを出力
        sql_log(result)

        return result
      end
    end

    # トランザクション開始
    def transaction
      @db.transaction
    end

    # ロールバック実行
    def rollback
      @db.rollback
    end

    # コミット実行
    def commit
      @db.commit
    end

    # SQLのログ
    def sql_log(result)
      # ログ情報
      params = Array.new

      # エラーなら1を、エラーでなければ0を格納する
      if(result[:error]) then
        params[0] = -1
      else
        params[0] = 0
      end
      # 各種情報を格納する
      params[1] = result[:message]
      params[2] = result[:sql]
      params[3] = result[:params]
      params[4] = Time.now.strftime($DATE_FORMAT)

      sql =  "INSERT INTO SQL_LOG("
      sql += " EXECUTE_STATE,"
      sql += " MESSAGE,"
      sql += " EXECUTE_SQL,"
      sql += " PARAMS,"
      sql += " EXECUTE_TIME"
      sql += ") VALUES (?,?,?,?,?);"

      # プリペアドステートメントを設定します
      stmt = @db.prepare(sql)

      begin
        # トランザクションを開始します
        @db.transaction do
          # バインド変数の設定を行います
          stmt.execute(params)
        end
        #
        @log.info("SQLログの登録に成功しました！")
      rescue => e
        @log.error("SQLログの登録に失敗しました。エラーメッセージ："+ e.message)
      end
    end

    def do_rest
      puts self.class.name + "を休憩状態に以降します。"
    end
  end
end
