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
  class SelectTable
    def initialize
      @db = SQLite3::Database.new($memory_root)
      @common = MemoryManager::MemoryCommon.new
    end

    def execute
      begin
        db_result = @db.execute("SELECT * FROM SQLITE_MASTER;")

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| テーブル一覧"
        puts "|"

        # テーブル情報を表示
        @common.view_table_names(db_result)

        puts "|"
        print "| 操作を行うには「Enter」キーを入力してください"
        gets

      rescue => e
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| ＳＱＬは以下の理由により失敗しました。"
        puts "| " + e.message
        puts "|"
      end

      return true
    end
  end
end
