# usr/bin/ruby
# coding:utf-8

=begin rdoc
=RestoreTable
==Rocinanteの記憶プログラム

=end

require 'sqlite3'
require 'fileutils'

module MemoryManager
  # Memoryクラス
  class RestoreTable
    def initialize
      @db = SQLite3::Database.new($memory_root)
      @common = MemoryManager::MemoryCommon.new
    end

    def execute
      table_no_flg = true
      restore_no_flg = true

      begin
        db_result = @db.execute("SELECT * FROM SQLITE_MASTER;")
      rescue => e
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| ＳＱＬは以下の理由により失敗しました。"
        puts "| " + e.message
        print "|\n|「Enter」キーを入力してください。"
        gets

        table_no_flg = false
        restore_no_flg = false
      end

      while(table_no_flg)
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "| テーブル一覧"
        puts "|"

        # テーブル情報を表示
        table_names = @common.view_table_names(db_result)

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| バックアップ対象のテーブルNoを入力してください=> "

        table_no = gets.chomp

        # 入力が99の場合はメニューに戻ります。
        if( @common.back_menu?(table_no) ) then
          return true
        end

        # 入力値が数字かつテーブル情報の数より小さかった場合
        if(/^[1-9]([0-9]*)$/ =~ table_no) && (table_no.to_i <= table_names.length) then
          table_name = table_names[table_no.to_i]
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| テーブルNoは正しく指定してください。"
          puts "|"
          next
        end

        table_no_flg = false
      end

      while(restore_no_flg)
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "| リストア先一覧"
        puts "|"

        # テーブル情報を表示
        restore_dates = @common.view_restore_table(table_name)

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| リストア対象の日付Noを入力してください=> "

        restore_no = gets.chomp

        # 入力が99の場合はメニューに戻ります。
        if( @common.back_menu?(restore_no) ) then
          return true
        end

        # 入力値が数字かつバックアップ情報の数より小さかった場合
        if(/^[1-9]([0-9]*)$/ =~ table_no) && (restore_no.to_i <= restore_dates.length) then
          restore_file = restore_dates[restore_no.to_i]

          # バックアップを行います。
          bk_result = @common.backup_table(table_name)

          # バックアップ結果に応じて処理を行う。
          if(bk_result) then
            # テーブルのリストアを実行
            @common.restore_table(table_name, restore_file)

            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| テーブル「" + table_names[table_no] + "」のリストアが完了しました。"
            print "|\n|「Enter」キーを入力してください。"
            gets
          else
            # バックアップに失敗したため、中止します。
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「"+ table_names[table_no] +"」のバックアップに失敗したため、リストアを中止します。"
            print "|\n|「Enter」キーを入力してください。"
            gets
          end
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| 日付Noは正しく指定してください。"
          puts "|"
          next
        end

        table_no_flg = false
      end

      # メニューに戻る
      return true
    end
  end
end
