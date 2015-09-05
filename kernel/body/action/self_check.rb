# usr/bin/ruby
# coding:utf-8

=begin rdoc
=SelfCheck
==RocinanteのAction

=end

module Rocinante
    class SelfCheck < ActionBase
    def execute
      @self_check_id =  Time.now.strftime("%Y%m%d%H%M%S")

      begin
        ["check_memory", "check_cpu", "check_disk"].each do |method|
          # 文字列のメソッドを実行
          result = send(method)

          if( result[:error] ) then
            @log.error( result[:message] )
          else
            @log.info( result[:message] )
          end

          puts result[:message]
        end

        # 実行結果を各種変数に格納
        @action_info[:result] = 2
        @action_info[:result_detail] = "CPU、メモリ、ディスク容量のチェックを行いました！"
      rescue => e
        puts self.class.name + "でエラーが発生しました。エラーメッセージ:" + e.message
        @log.error(self.class.name + "でエラーが発生しました。エラーメッセージ:" + e.message)

        # 実行結果を各種変数に格納
        @action_info[:result] = -1
        @action_info[:result_detail] = self.class.name + "でエラーが発生しました。エラーメッセージ:" + e.message
      end
    end

    def check_memory
      exec_result = linux_exec("free")

      # 実行結果がエラーの場合はそのまま返却
      if( exec_result[:error] ) then
        return exec_result
      end

      # データを整形し配列に格納
      memory_data = exec_result[:data][1].split(/\s+/)

      # インサートデータを生成
      insert_data = Hash.new
      insert_data[:self_check_id] = @self_check_id
      insert_data[:used_percent] = (memory_data[2].to_f / memory_data[1].to_f * 100.0).round(2)
      insert_data[:total] = memory_data[1]
      insert_data[:used] = memory_data[2]
      insert_data[:free] = memory_data[3]
      insert_data[:shared] = memory_data[4]
      insert_data[:buffers] = memory_data[5]
      insert_data[:cached] = memory_data[6]
      insert_data[:update_date] = Time.now.strftime($DATE_FORMAT)

      # データのインサート
      $memory.insert("RC_PC_MEMORY", insert_data)

      return exec_result
    end

    def check_cpu
      exec_result = linux_exec("uptime")

      # 実行結果がエラーの場合はそのまま返却
      if( exec_result[:error] ) then
        return exec_result
      end

      # データを整形し配列に格納
      cpu_data = exec_result[:data][0].split("average: ")[1].split(", ")

      # インサートデータを生成
      insert_data = Hash.new
      insert_data[:self_check_id] = @self_check_id
      insert_data[:load_average_1m] = cpu_data[0]
      insert_data[:load_average_5m] = cpu_data[1]
      insert_data[:load_average_15m] = cpu_data[2]
      insert_data[:update_time] = Time.now.strftime($DATE_FORMAT)

      # データのインサート
      $memory.insert("RC_PC_CPU", insert_data)

      return exec_result
    end

    def check_disk
      # 物理ディスクの情報を取得
      exec_result = linux_exec("df | grep -v tmpfs | grep /dev/")

      # 実行結果がエラーの場合はそのまま返却
      if( exec_result[:error] ) then
        return exec_result
      end

      exec_result[:data].each do |disk_info|
        # dfの結果をスペースごとに区切る
        disk_data = disk_info.split(/\s+/)

        # インサートデータを生成
        insert_data = Hash.new
        insert_data[:self_check_id] = @self_check_id
        insert_data[:used_percent] = (disk_data[2].to_f / disk_data[1].to_f * 100.0).round(2)
        insert_data[:mount_point] = disk_data[5]
        insert_data[:file_system] = disk_data[0]
        insert_data[:total] = disk_data[1]
        insert_data[:used] = disk_data[2]
        insert_data[:available] = disk_data[3]
        insert_data[:mount_point] = disk_data[5]
        insert_data[:update_date] = Time.now.strftime($DATE_FORMAT)

        # データのインサート
        $memory.insert("RC_PC_DISK", insert_data)
      end

      return exec_result
    end

    def linux_exec(command)
      # コマンドを実行
      command_result = systemu( command )

      # コマンドにエラー出力が空文字だった場合
      if( command_result[2] != "" ) then
        return{
          error: true,
          message: "「" + command + "」の実行に失敗しました。"
        }
      end

      # エラーが無かった場合は
      return{
        error: false,
        message: "「" + command + "」の実行に成功しました！",
        data: command_result[1].split("\n")
      }
    end
  end
end
