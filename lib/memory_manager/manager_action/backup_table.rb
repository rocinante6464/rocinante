# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Memory
==Rocinanteの記憶プログラム
  Rocinanteは、前に行った行動を記憶できます。
  記憶すること、記憶から呼び出すことを管理します。
=end

require 'sqlite3'
require 'fileutils'

module MemoryManager
  # Memoryクラス
  class BackupTable
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
          print "|\n|「Enter」キーを入力してください。"
          gets
          table_no_flg = false
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
          return false
        end

        # 入力値が数字かつテーブル情報の数より小さかった場合
        if(/^[1-9]([0-9]*)$/ =~ table_no) && (table_no.to_i <= table_names.length) then
          table_no = table_no.to_i

          bk_result = @common.backup_table(table_names[table_no])

          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| テーブル「" + table_names[table_no] + "」のバックアップが完了しました。"
          print "|\n|「Enter」キーを入力してください。"
          gets
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| テーブルNoは正しく指定してください。"
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
