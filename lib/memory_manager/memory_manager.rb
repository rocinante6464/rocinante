# usr/bin/ruby
# coding:utf-8

=begin rdoc
=MemoryManager
==Rocinanteの記憶管理プログラム
  Rocinanteの記憶管理をするプログラムです。
=end

# 記憶のマスタ管理を全て読み込む
Dir[File.expand_path('../manager_action', __FILE__) << '/*.rb'].each do |file|
  require file
end

$memory_root = File.dirname(__FILE__) + "/../kernel/brain/memory/rocinante.db"

module MemoryManager
  class FinishMangement
    def execute
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| Rocinanteデータベースマネージャーを終了します。"
      puts "|"
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

      return false
    end
  end
end

begin
  # 再ループフラグ
  reloop_flg = true

  # コマンドを格納するハッシュ
  commands = Hash.new
  commands[1] = "MemoryManager::SelectTable"
  commands[2] = "MemoryManager::CreateTable"
  commands[3] = "MemoryManager::UpdateTable"
  commands[4] = "MemoryManager::DropTable"
  commands[5] = "MemoryManager::BackupTable"
  commands[6] = "MemoryManager::RestoreTable"
  commands[7] = "MemoryManager::BackupDatabase"
  commands[8] = "MemoryManager::RestoreDatabase"
  commands[9] = "MemoryManager::FinishMangement"

  while( reloop_flg )
    puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    puts "|"
    puts "| Rocinante データベースマネージャー"
    puts "|"
    puts "| -------------------------------------"
    puts "| ©2015 Rocinante Project"
    puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    puts "|"
    puts "| => 1 :  テーブル一覧の表示"
    puts "| => 2 :  テーブルの作成"
    puts "| =>   :  テーブルの編集\t\t*未実装です"
    puts "| => 4 :  テーブルの削除"
    puts "| => 5 :  テーブルのバックアップ"
    puts "| =>   :  テーブルのリストア\t\t*未実装です"
    puts "| =>   :  データベースのバックアップ\t*未実装です"
    puts "| =>   :  データベースのリストア\t*未実装です"
    puts "| => 9 :  テーブル管理を終了"
    puts "|"
    puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    print "| コマンドを入力してください => "

    # ユーザからの入力コマンドを変数に格納
    command = gets.chomp

    # 入力エラーチェック（0-9以外か）
    if /^([1-9])$/ =~ command then
      command = command.to_i
    else
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| コマンドは1〜9で指定してください。"
      puts "|"

      next
    end

    # 入力のあったコマンドに値するクラスを実行
    action_class = Object.const_get(commands[command]).new

    # アクションを実行します
    reloop_flg = action_class.execute
  end
rescue => e
  puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
  puts "|"
  puts "| 以下のエラーが発生しました。"
  puts "| " + e.message
  puts "|"
end
