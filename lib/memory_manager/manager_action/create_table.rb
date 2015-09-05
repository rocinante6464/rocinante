# usr/bin/ruby
# coding:utf-8

=begin rdoc
=MemoryManager
==Rocinanteの記憶マスタマネージャー
  記憶マスタを作成するためのマネージャーです。
=end

require 'sqlite3'
require File.dirname(__FILE__) + '/memory_common.rb'

module MemoryManager
  # Memoryクラス
  class CreateTable
    def initialize
      @columns = {1 => "TEXT",
                  2 => "INTEGER",
                  3 => "REAL",
                  4 => "BLOB"}

      @methods = {1 => "input_column_info",
                  2 => "update_column_info",
                  3 => "delete_column_info",
                  4 => "check_columns_info",
                  5 => "execute_create"}

      @db = SQLite3::Database.new($memory_root)
      @common = MemoryManager::MemoryCommon.new
      @table_name
      @column_infos = Array.new
    end

    def execute
      reloop_flg = true
      columns = Array.new

      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| テーブルの作成を行います。"
      puts "|"

      # テーブル名の設定
      if( input_table_name ) then
        return true
      end

      while(reloop_flg)

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| => 99:  テーブルの作成を中止しメニューに戻る"
        puts "|"
        puts "| テーブル「" + @table_name + "」を作成します"
        puts "|"
        puts "| => 1 :  カラムを追加する"
        puts "| => 2 :  カラムを編集する"
        puts "| => 3 :  カラムを削除する"
        puts "| => 4 :  カラムの設定状況を確認する"
        puts "| => 5 :  テーブルを作成する"
        puts "|"
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| コマンドを入力してください => "

        # ユーザからの入力コマンドを変数に格納
        command = gets.chomp

        # 入力が99の場合はメニューに戻ります。
        if( @common.back_menu?(command) ) then
          return true
        end

        # 入力エラーチェック（1-5以外か）
        if /^([1-5])$/ =~ command then

          begin
            # メソッドの実行
            if( send(@methods[command.to_i]) ) then
              return true
            end

            # SQLの実行に成功し、コマンドが５だった場合テーブル作成終了
            if( command.to_i == 5 )
              reloop_flg = false
            end

          # SQLの実行が失敗した場合
          rescue => e
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| テーブル作成は以下の理由により失敗しました。"
            puts "| " + e.message
            puts "|"
          end
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| コマンドは1〜5で指定してください。"
          puts "|"

          next
        end
      end

      # テーブル作成を終了します。
      return true
    end

    # テーブル名の設定
    def input_table_name
      # DBに入れるカラムの情報について対話形式で取得する
      while(true)
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| => 99: メニューに戻る"
        puts "|"
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| テーブル名を入力してください => "

        table_name = ((gets.chomp).to_s).strip

        # 入力が99の場合はメニューに戻ります。
        if( @common.back_menu?(table_name) ) then
          return true
        end

        begin
          # 指定のテーブルと同名のテーブルがあるか調べます。
          db_result = @db.execute("SELECT * FROM " + table_name.upcase! + ";")
        rescue => e
          # 入力が指定の言葉の場合はテーブル名入力に戻ります。
          if( @common.ignore_keyword?(table_name) ) then
            next
          end

          # 同名のテーブルが無かった場合
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| => 99: テーブル名登録をやめてメニューに戻る"
          puts "|"
          puts "| テーブル名「" + table_name + "」で確定しますか？"
          puts "| はい   => y, yes"
          puts "| いいえ => それ以外"
          puts "|"
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          print "| コマンドを入力してください => "

          command = gets.chomp

          # 入力が99の場合はメニューに戻ります。
          if( @common.back_menu?(command) ) then
            return true
          end

          # ユーザからの入力値がyesまたはyのとき
          if(command.to_s == "yes") || (command.to_s == "y")
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| テーブル「" + table_name +"」を作成します。"
            puts "|"

            # テーブル名を確定する
            @table_name = table_name

            # エラー無し
            return false
          else
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| テーブル名の確定はキャンセルされました。"
            puts "|"
          end

          next
        end

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| そのテーブル名は使用されています。"
        puts "| もう一度入力してください。"
        puts "|"
      end
    end

    # カラム情報の入力
    def input_column_info
      column_name_flg = true
      column_type_flg = true
      column_pk_flg = true
      column_autoinc_flg = true
      column_notnull_flg = true

      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| カラムの追加を行います。"
      puts "|"

      # カラム名の入力
      while( column_name_flg )
        # カラム情報格納用変数
        column_info = Hash.new

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| => 99:  カラム追加をやめてテーブル作成メニューに戻る"
        puts "|"
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| カラム名を入力してください => "

        # 標準入力から入力を待ちます
        column_info[:name] = ((gets.chomp).to_s).strip

        # 入力が99の場合はメニューに戻ります。
        if( back_create_menu?(column_info[:name]) ) then
          return true
        end

        # ＳＱＬ予約語を使っていないかチェック
        if @common.ignore_keyword?(column_info[:name].upcase!) then
          next
        end

        column_name_flg = false
      end

      # カラムタイプの入力チェック
      while(column_type_flg)
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| カラム名「" + column_info[:name] + "」の型を選択してください。"
        puts "|"
        puts "| => 99:  カラム追加をやめてテーブル作成メニューに戻る"
        puts "|"
        puts "| => 1 :  テキスト　　　　->TEXT"
        puts "| => 2 :  符号付き整数　　->INTEGER"
        puts "| => 3 :  浮動小数点数　　->REAL"
        puts "| => 4 :  バイナリデータ　->BLOB"
        puts "|"
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| コマンドを入力してください => "

        command = gets.chomp

        # 入力が99の場合はメニューに戻ります。
        if( back_create_menu?(command) ) then
          return false
        end

        # 入力エラーチェック（1-5以外か）
        if /^([1-5])$/ =~ command then
          column_info[:type] = @columns[command.to_i]
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| コマンドは1〜5で指定してください。"
          puts "|"

          next
        end

        column_type_flg = false
      end

      # カラムの主キー確認
      while(column_pk_flg)
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| => 99: カラム追加をやめてメニューに戻る"
        puts "|"
        puts "| 「" + column_info[:name] + "」を主キーに設定しますか？"
        puts "| はい   => y, yes"
        puts "| いいえ => それ以外"
        puts "|"
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| コマンドを入力してください => "

        command = gets.chomp

        # 入力が99の場合はメニューに戻ります。
        if( back_create_menu?(command) ) then
          return true
        end

        # ユーザからの入力値がyesまたはyのとき
        if(command.to_s == "yes") || (command.to_s == "y")
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| 「" +  column_info[:name] +"」を主キーに設定しました。"
          puts "|"

          column_info[:pk] = 1
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| 「" +  column_info[:name] +"」を主キーに設定しませんでした。"
          puts "|"

          column_info[:pk] = 0
        end

        column_pk_flg = false
      end

      if(column_info[:type] == "INTEGER") && (column_info[:pk] == 1) then
        # カラムのオートインクリメント確認
        while(column_autoinc_flg)
          # 同名のテーブルが無かった場合
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| => 99: カラム追加をやめてテーブル作成メニューに戻る"
          puts "|"
          puts "| 「" + column_info[:name] + "」をオートインクリメントに設定しますか？"
          puts "| 設定するとデータインサート時に一意の整数を入れてくれます。"
          puts "|"
          puts "| はい   => y, yes"
          puts "| いいえ => それ以外"
          puts "|"
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          print "| コマンドを入力してください => "

          command = gets.chomp

          # 入力が99の場合はメニューに戻ります。
          if( back_create_menu?(command) ) then
            return true
          end

          # ユーザからの入力値がyesまたはyのとき
          if(command.to_s == "yes") || (command.to_s == "y") then
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「" +  column_info[:name] +"」をオートインクリメントに設定しました。"
            puts "|"

            column_info[:autoinc] = true
          else
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「" +  column_info[:name] +"」をオートインクリメントに設定しませんでした。"
            puts "|"

            column_info[:autoinc] = false
          end

          column_autoinc_flg = false
        end
      else
        column_info[:autoinc] = false
      end


      if(column_info[:pk] == 0) then
        # カラムのNot Null確認
        while(column_notnull_flg)
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| => 99: カラム追加をやめてメニューに戻る"
          puts "|"
          puts "| 「" + column_info[:name] + "」をNull値禁止に設定しますか？"
          puts "| はい   => y, yes"
          puts "| いいえ => それ以外"
          puts "|"
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          print "| コマンドを入力してください => "

          command = gets.chomp

          # 入力が99の場合はメニューに戻ります。
          if( back_create_menu?(command) ) then
            return true
          end

          # ユーザからの入力値がyesまたはyのとき
          if(command.to_s == "yes") || (command.to_s == "y")
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「" +  column_info[:name] +"」をNull値禁止に設定しました。"
            puts "|"

            column_info[:notnull] = 1
          else
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「" +  column_info[:name] +"」をNull値可能に設定しました。"
            puts "|"

            column_info[:notnull] = 0
          end

          column_notnull_flg = false
        end
      else
        column_info[:notnull] = 0
      end

      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| カラム情報を設定しました！"

      view_column_detail(column_info)

      puts "|"
      @column_infos[@column_infos.length] = column_info

      # カラム情報の入力が正しく完了した
      return false
    end

    def update_column_info
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| カラムの編集を行います。"
      puts "|"

      column_no_flg = true

      while(column_no_flg)

        puts "|"
        puts "| => 99: カラム編集をやめてテーブル作成メニューに戻る"
        puts "|"

        view_column_infos

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| 編集対象のカラムNoを入力してください=> "

        column_no = gets.chomp

        # 入力が99の場合はメニューに戻ります。
        if( back_create_menu?(column_no) ) then
          return false
        end

        # 入力値が数字かつカラム情報の数より小さかった場合
        if(/^[1-9]([0-9]*)$/ =~ column_no) && (column_no.to_i <= @column_infos.length) then
          # 各フラグの初期化
          column_name_flg = true
          column_type_flg = true
          column_pk_flg = true
          column_autoinc_flg = true
          column_notnull_flg = true

          # カラム名の入力
          while( column_name_flg )
            # カラム情報格納用変数
            column_info = Hash.new
            old_column_info = @column_infos[column_no.to_i - 1]

            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| => 99:  カラム編集をやめてテーブル作成メニューに戻る"
            puts "|"
            puts "| 現在のカラム名：" + old_column_info[:name]
            puts "| -更新しない場合は「Enter」キーを入力してください"
            puts "|"
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            print "| カラム名を入力してください => "

            # 標準入力から入力を待ちます
            input_value = ((gets.chomp).to_s).strip

            # 入力が99の場合はメニューに戻ります。
            if( back_create_menu?(input_value) ) then
              return true
            end

            # ＳＱＬ予約語を使っていないかチェック
            if @common.ignore_keyword?(input_value.upcase!) then
              next
            end

            # 入力があった場合は更新する
            if( input_value != "" ) then
              column_info[:name] = input_value
            else
              column_info[:name] = old_column_info[:name]
            end

            column_name_flg = false
          end

          # カラムタイプの入力チェック
          while(column_type_flg)
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| カラム名「" + column_info[:name] + "」の型を選択してください。"
            puts "|"
            puts "| => 99:  カラム編集をやめてテーブル作成メニューに戻る"
            puts "|"
            puts "| => 1 :  テキスト　　　　->TEXT"
            puts "| => 2 :  符号付き整数　　->INTEGER"
            puts "| => 3 :  数値　　　　　　->NUMERIC"
            puts "| => 4 :  浮動小数点数　　->REAL"
            puts "| => 5 :  バイナリデータ　->NONE"
            puts "|"
            puts "| 現在のカラムの型：" + old_column_info[:type]
            puts "| -更新しない場合は「Enter」キーを入力してください"
            puts "|"
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            print "| コマンドを入力してください => "

            command = gets.chomp

            # 入力が99の場合はメニューに戻ります。
            if( back_create_menu?(command) ) then
              return false
            end

            # 入力エラーチェック（1-5以外か）
            if(/^([1-5])$/ =~ command) then
              column_info[:type] = @columns[command.to_i]
            elsif( command.to_s == "" ) then
              column_info[:type] = old_column_info[:type]
            else
              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
              puts "|"
              puts "| コマンドは1〜5で指定してください。"
              puts "|"

              next
            end

            column_type_flg = false
          end

          # カラムの主キー確認
          while(column_pk_flg)
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| => 99: カラム編集をやめてメニューに戻る"
            puts "|"
            puts "| 「" + column_info[:name] + "」を主キーに設定しますか？"
            puts "| はい   => y, yes"
            puts "| いいえ => それ以外"
            puts "|"
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            print "| コマンドを入力してください => "

            command = gets.chomp

            # 入力が99の場合はメニューに戻ります。
            if( back_create_menu?(command) ) then
              return true
            end

            # ユーザからの入力値がyesまたはyのとき
            if(command.to_s == "yes") || (command.to_s == "y")
              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
              puts "|"
              puts "| 「" +  column_info[:name] +"」を主キーに設定しました。"
              puts "|"

              column_info[:pk] = 1
            else
              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
              puts "|"
              puts "| 「" +  column_info[:name] +"」を主キーに設定しませんでした。"
              puts "|"

              column_info[:pk] = 0
            end

            column_pk_flg = false
          end

          if(column_info[:type] == "INTEGER") && (column_info[:pk] == 1) then
            # カラムのオートインクリメント確認
            while(column_autoinc_flg)
              # 同名のテーブルが無かった場合
              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
              puts "|"
              puts "| => 99: カラム編集をやめてテーブル作成メニューに戻る"
              puts "|"
              puts "| 「" + column_info[:name] + "」をオートインクリメントに設定しますか？"
              puts "| 設定するとデータインサート時に一意の整数を入れてくれます。"
              puts "|"
              puts "| はい   => y, yes"
              puts "| いいえ => それ以外"
              puts "|"
              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
              print "| コマンドを入力してください => "

              command = gets.chomp

              # 入力が99の場合はメニューに戻ります。
              if( back_create_menu?(command) ) then
                return true
              end

              # ユーザからの入力値がyesまたはyのとき
              if(command.to_s == "yes") || (command.to_s == "y") then
                puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
                puts "|"
                puts "| 「" +  column_info[:name] +"」をオートインクリメントに設定しました。"
                puts "|"

                column_info[:autoinc] = true
              else
                puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
                puts "|"
                puts "| 「" +  column_info[:name] +"」をオートインクリメントに設定しませんでした。"
                puts "|"

                column_info[:autoinc] = false
              end

              column_autoinc_flg = false
            end
          else
            column_info[:autoinc] = false
          end


          if(column_info[:pk] == 0) then
            # カラムのNot Null確認
            while(column_notnull_flg)
              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
              puts "|"
              puts "| => 99: カラム編集をやめてメニューに戻る"
              puts "|"
              puts "| 「" + column_info[:name] + "」をNull値禁止に設定しますか？"
              puts "| はい   => y, yes"
              puts "| いいえ => それ以外"
              puts "|"
              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
              print "| コマンドを入力してください => "

              command = gets.chomp

              # 入力が99の場合はメニューに戻ります。
              if( back_create_menu?(command) ) then
                return true
              end

              # ユーザからの入力値がyesまたはyのとき
              if(command.to_s == "yes") || (command.to_s == "y")
                puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
                puts "|"
                puts "| 「" +  column_info[:name] +"」をNull値禁止に設定しました。"
                puts "|"

                column_info[:notnull] = 1
              else
                puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
                puts "|"
                puts "| 「" +  column_info[:name] +"」をNull値可能に設定しました。"
                puts "|"

                column_info[:notnull] = 0
              end

              column_notnull_flg = false
            end
          else
            column_info[:notnull] = 0
          end

          column_no_flg = false
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| カラムNoは正しく指定してください。"
          puts "|"

          next
        end
      end

      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "| "
      puts "| 更新前："
      view_column_detail(old_column_info)
      puts "| "
      puts "| 更新後："
      view_column_detail(column_info)

      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| => 99: カラムの編集をやめてメニューに戻る"
      puts "|"
      puts "| 本当にカラムを更新してよろしいですか？"
      puts "| はい   => y, yes"
      puts "| いいえ => それ以外"
      puts "|"
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      print "| コマンドを入力してください => "

      command = gets.chomp

      # 入力が99の場合はメニューに戻ります。
      if( back_create_menu?(command) ) then
        return false
      end

      # ユーザからの入力値がyesまたはyのとき
      if(command.to_s == "yes") || (command.to_s == "y")
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| 「"+ column_info[:name] +"」を更新しました！"
        puts "|"

        # カラムを更新
        @column_infos[column_no.to_i - 1] = column_info

        # エラー無し
        return false
      else
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| 「"+ column_info[:name] +"」の更新はキャンセルされました。"
        puts "|"

        return false
      end
    end

    def delete_column_info
      column_no_flg = true
      delete_column_flg = true

      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| カラムの削除を行います。"
      puts "|"

      while(column_no_flg)
        puts "|"
        puts "| => 99: カラム削除をやめてテーブル作成メニューに戻る"
        puts "|"

        view_column_infos

        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        print "| 削除対象のカラムNoを入力してください=> "

        column_no = gets.chomp

        # 入力が99の場合はメニューに戻ります。
        if( back_create_menu?(column_no) ) then
          return false
        end

        # 入力値が数字かつカラム情報の数より小さかった場合
        if(/^[1-9]([0-9]*)$/ =~ column_no) && (column_no.to_i <= @column_infos.length) then
          column_no = column_no.to_i
          column_info = @column_infos[column_no - 1]

          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"

          # 削除対象のカラム情報を表示する
          view_column_detail(column_info)

          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| => 99: カラムの削除をやめてメニューに戻る"
          puts "|"
          puts "| 本当にカラムを削除してよろしいですか？"
          puts "| はい   => y, yes"
          puts "| いいえ => それ以外"
          puts "|"
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          print "| コマンドを入力してください => "

          command = gets.chomp

          # 入力が99の場合はメニューに戻ります。
          if( back_create_menu?(command) ) then
            return false
          end

          # ユーザからの入力値がyesまたはyのとき
          if(command.to_s == "yes") || (command.to_s == "y")
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「"+ column_info[:name] +"」を削除しました！"
            puts "|"

            @column_infos.delete_at(column_no - 1)

            # エラー無し
            return false
          else
            puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
            puts "|"
            puts "| 「"+ column_info[:name] +"」の削除はキャンセルされました。"
            puts "|"

            return false
          end
        else
          puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
          puts "|"
          puts "| カラムNoは正しく指定してください。"
          puts "|"

          next
        end

        column_no_flg = false
      end

      return false
    end

    # カラムを確認します。
    def check_columns_info
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| カラムの確認を行います。"
      puts "|"

      view_column_infos

      print "|\n|「Enter」キーを入力してください。"
      gets

      return false
    end

    def execute_create
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| ＳＱＬの実行を行います。"
      puts "|"

      # SQLを実行する
      @db.execute( @common.create_table_sql(@table_name, @column_infos) )

      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| テーブル「" + @table_name + "」を作成しました！"
      print "|\n|「Enter」キーを入力してください。"
      gets
      return false
    end

    def back_create_menu?(command)
      # ユーザの入力99の場合はメニューに戻ります
      if( command.to_i == 99 ) then
        # メニューにもどります
        puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
        puts "|"
        puts "| テーブル作成メニューに戻ります。"
        print "|\n|「Enter」キーを入力してください。"
        gets
        return true;
      end

      # それ以外の場合は戻りません。
      return false;
    end

    # 情報を表示する
    def view_column_infos
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "|"
      puts "| テーブル名「" + @table_name + "」"


      for index in 0...@column_infos.length
        column_info = @column_infos[index]

        puts "|"
        print "| カラムNo." + (index + 1).to_s +
               "\tカラム名 ：" + column_info[:name] +
               "\tカラム種別：" + column_info[:type] + "\n"

        print "|\t"

        if column_info[:pk] == 1 then
          print "\t主キー設定 "
        end

        if column_info[:autoinc] then
          print "\tオートインクリメント設定 "
        end

        if column_info[:notnull] == 1 then
          print "\tNull値の禁止設定"
        end

        print "\n"
      end
    end

    # 詳細を表示する
    def view_column_detail(column_info)
      puts "| カラム名　：" + column_info[:name]
      puts "| カラム種別：" + column_info[:type]
      if column_info[:pk] == 1 then
        puts "| 主キー設定済み"
      end
      if column_info[:autoinc] then
        puts "| オートインクリメント設定済み"
      end
      if column_info[:notnull] == 1 then
        puts "| Null値の禁止設定"
      end
    end
  end
end
