# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Memory
==Rocinanteの記憶プログラム
  Rocinanteは、前に行った行動を記憶できます。
  記憶すること、記憶から呼び出すことを管理します。
=end

require 'sqlite3'

module MemoryManager
  # Memoryクラス
  class DropTable
    def initialize
      @db = SQLite3::Database.new($memory_root)
      @common = MemoryManager::MemoryCommon.new
    end

    def execute
      table_no_flg = true

      begin
        db_result = @db.execute("SELECT * FROM SQLITE_MASTER;")
      rescue => e
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| ＳＱＬは以下の理由により失敗しました。"
          puts "| " + e.message
          puts "|"

          table_no_flg = false
      end

      while(table_no_flg)
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "| テーブル一覧"
        puts "|"

        # テーブル情報を表示
        table_names = @common.view_table_names(db_result)

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| 削除対象のテーブルNoを入力してください=> "

        table_no = gets.chomp

        # 入力が99の場合はメニューに戻ります。
        if( @common.back_menu?(table_no) ) then
          return false
        end

        # 入力値が数字かつテーブル情報の数より小さかった場合
        if(/^[1-9]([0-9]*)$/ =~ table_no) && (table_no.to_i <= table_names.length) then
          table_no = table_no.to_i

          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| => 99: テーブルの削除をやめてメニューに戻る"
          puts "|"
          puts "| 本当にテーブル「" + table_names[table_no] + "」を削除してよろしいですか？"
          puts "| はい   => y, yes"
          puts "| いいえ => それ以外"
          puts "|"
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          print "| コマンドを入力してください => "

          command = gets.chomp

          # 入力が99の場合はメニューに戻ります。
          if( @common.back_menu?(command) ) then
            return false
          end

          # ユーザからの入力値がyesまたはyのとき
          if(command.to_s == "yes") || (command.to_s == "y")
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「"+ table_names[table_no] +"」を削除しました！"
            puts "|"

            # 削除前にバックアップをとります
            bk_result = @common.backup_table(table_names[table_no.to_i])

            # バックアップ結果に応じて処理を行う。
            if(bk_result) then
              @common.drop_table(table_names[table_no])
            else
              # バックアップに失敗したため、中止します。
              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
              puts "|"
              puts "| 「"+ table_names[table_no] +"」のバックアップに失敗したため、削除を中止します。"
              puts "|"
            end
          else
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「"+ table_names[table_no] +"」の削除はキャンセルされました。"
            puts "|"

            next
          end
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| テーブルNoは正しく指定してください。"
          puts "|"

          next
        end

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| 「"+ table_names[table_no] +"」を削除しました。"
        puts "|"

        table_no_flg = false
      end

      # メニューに戻る
      return true
    end
  end
end
