# usr/bin/ruby
# coding:utf-8

=begin rdoc
=MemoryCommon
==Rocinanteの記憶管理共通クラス
  記憶管理共通クラスで使用されるクラスです。
  画面・コンソール・バッチで使用されます。
=end

require 'sqlite3'

module MemoryManager
  class MemoryCommon
    # 定数宣言
    TRANSACTION = "BEGIN TRANSACTION;"
    COMMIT      = "COMMIT;"

    def initialize
      # 拒否キーワードを定義
      @ignore_keywords = ['ABORT','ACTION','ADD','AFTER','ALL','ALTER','ANALYZE','AND','AS','ASC','ATTACH','AUTOINCREMENT','BEFORE','BEGIN','BETWEEN','BY','CASCADE','CASE','CAST','CHECK','COLLATE','COLUMN','COMMIT','CONFLICT','CONSTRAINT','CREATE','CROSS','CURRENT_DATE','CURRENT_TIME','CURRENT_TIMESTAMP','DATABASE','DEFAULT','DEFERRABLE','DEFERRED','DELETE','DESC','DETACH','DISTINCT','DROP','EACH','ELSE','END','ESCAPE','EXCEPT','EXCLUSIVE','EXISTS','EXPLAIN','FAIL','FOR','FOREIGN','FROM','FULL','GLOB','GROUP','HAVING','IF','IGNORE','IMMEDIATE','IN','INDEX','INDEXED','INITIALLY','INNER','INSERT','INSTEAD','INTERSECT','INTO','IS','ISNULL','JOIN','KEY','LEFT','LIKE','LIMIT','MATCH','NATURAL','NO','NOT','NOTNULL','NULL','OF','OFFSET','ON','OR','ORDER','OUTER','PLAN','PRAGMA','PRIMARY','QUERY','RAISE','RECURSIVE','REFERENCES','REGEXP','REINDEX','RELEASE','RENAME','REPLACE','RESTRICT','RIGHT','ROLLBACK','ROW','SAVEPOINT','SELECT','SET','TABLE','TEMP','TEMPORARY','THEN','TO','TRANSACTION','TRIGGER','UNION','UNIQUE','UPDATE','USING','VACUUM','VALUES','VIEW','VIRTUAL','WHEN','WHERE','WITH','WITHOUT',',','SQLITE']
      @db = SQLite3::Database.new($memory_root)
    end

    # 拒否キーワードかを確認する
    def ignore_keyword?(input)
      # 禁止キーワードに該当する場合true
      for index in 0...@ignore_keywords.length
        if @ignore_keywords[index] == input
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| 「" + input + "」はシステム上使用できません"
          print "|\n|「Enter」キーを入力してください。"
          gets
          return true
        end
      end

      # 禁止キーワードに該当しない場合はfalse
      return false
    end

    # メニューに戻るかの確認用変数です。
    def back_menu?(command)
      # ユーザの入力99の場合はメニューに戻ります
      if( command.to_i == 99 ) then
        # メニューにもどります
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| メニューに戻ります。"
        puts "|"
        print "|\n|「Enter」キーを入力してください。"
        gets
        return true;
      end

      # それ以外の場合は戻りません。
      return false;
    end

    # テーブル一覧を表示
    def view_table_names(table_infos)
      table_names = Array.new
      index = 1

      for table_info in table_infos do
        if( system_table?(table_info[1]) ) then
          next
        end

        table_names[index] = table_info[1]
        puts "| => テーブルNo." + index.to_s + " : " + table_info[1]
        index += 1
      end

      return table_names
    end

    # リストアする日付リストを表示し、リストを返却する。
    def view_restore_table(table_name)
      restore_dates = Array.new
      index = 1

      # バックアップフォルダ内の情報を読み込む
      Dir[File.expand_path("../../backup/table/" + table_name , __FILE__) << '/*.sql'].each do |file|
        # 日付番号に対応したファイル名を配列に格納
        restore_dates[index] = file
        # 人に見やすい日付の形で表示
        puts "| => 日付No. " + index.to_s +  " : " + Time.at(File.basename(file, ".sql").to_i).strftime("%Y年 %m月 %d日 %H:%M:%S")
        index += 1
      end

      return restore_dates
    end

    # リストア処理
    def restore_table(table_name, restore_file)
      # リストアファイルを開いて中のＳＱＬを一行ずつ実行

    end

    def create_table_sql(table_name, column_infos)
      # SQL格納用変数
      sql = ""

      sql += "CREATE TABLE " + table_name + "("

      # カラムの情報を入れる
      for column_info in column_infos do
        # カラム名を設定
        sql += column_info[:name]
        # カラムタイプを設定
        sql += " " + column_info[:type]

        # 主キー情報を設定
        if(column_info[:pk] == 1) then
          sql += " PRIMARY KEY"

          # 主キーの場合は自動更新を設定
          if(column_info[:autoinc]) then
            sql += " AUTOINCREMENT"
          end

        # NUT NULL情報を設定
        elsif(column_info[:notnull] == 1) then
          sql += " NOT NULL"
        end

        # 次のカラムへのつなぎ
        sql += ","
      end

      # 末尾のカンマを覗いた文字に終端文字等を連結
      sql = sql.chop + ");"

      return sql
    end

    # テーブルの削除メソッド
    def drop_table(table_name)
      # ドロップテーブル
      sql = "DROP TABLE " + table_name + ";"

      begin
        @db.execute(sql)
      rescue
        return false
      end

      return true
    end

    # テーブルのバックアップ取得メソッド
    def backup_table(table_name)
      # ドロップテーブル文を取得
      drop_table = "DROP TABLE " + table_name + ";"
      # クリエイトテーブル文を取得
      create_table = get_table_info(table_name)[4] + ";"
      # インサートテーブル文を取得
      insert_data  = insert_table_sql(table_name)

      # ファイルに出力
      File.open(get_bk_table_file(table_name), "w") do |io|
        io.puts  TRANSACTION
        io.puts  drop_table
        io.puts  create_table
        io.print insert_data
        io.puts  COMMIT
      end

      return true
    end

    # テーブル構造取得メソッド
    def get_table_info(table_name)
      sql = "SELECT * FROM SQLITE_MASTER WHERE TBL_NAME = ?"

      # SQLを実行
      db_result = @db.execute(sql, table_name)

      return db_result[0]
    end

    # テーブルバックアップファイル名設定メソッド
    def get_bk_table_file(table_name)
      # 現在の日時を取得
      day = (Time.now.to_i).to_s
      # 指定のフォルダを設定
      bk_table_file = File.dirname(__FILE__) + "/../backup/table/" + table_name + "/"
      # バックアップディレクトリが無い場合作成
      FileUtils.mkdir_p(bk_table_file) unless FileTest.exist?(bk_table_file)

      # ファイル名を設定（UNIXタイムの数値）
      bk_table_file += day + ".sql"

      return bk_table_file
    end

    # インサート文作成メソッド
    def insert_table_sql(table_name)
      sql = ""
      # テーブル情報を全て取得します。
      table_column = get_table_column(table_name)
      table_data = get_table_data(table_name)

      # テーブルデータのＳＱＬ文を作成
      for data in table_data
        insert = "INSERT INTO " + table_name + "("
        values = " VALUES("
        index = 0

        for column in table_column
          # カラム名を設定
          insert += column[1] + ","

          # 型が文字列の場合はシングルクオートで囲む
          if( data[index].nil? ) then
            values += "null,"
          elsif( column[2] == "TEXT" ) then
            values += "\"" + data[index].to_s + "\","
          else
            values += data[index].to_s + ","
          end

          index += 1
        end

        insert = insert.chop + ")"
        values = values.chop + ");\n"
        sql += (insert + values)
      end

      return sql
    end

    # テーブル情報を取得
    def get_table_data(table_name)
      sql = "SELECT * FROM " + table_name + ";"
      db_result = @db.execute(sql)

      return db_result
    end

    # テーブルのカラム情報を取得
    def get_table_column(table_name)
      sql = "PRAGMA TABLE_INFO("+ table_name +");"
      db_result = @db.execute(sql)

      return db_result
    end

    # 引数で与えられたテーブル名がシステムテーブルかを判断するメソッド
    def system_table?(table_name)
        return (table_name.to_s).include?("sqlite")
    end
  end
end
