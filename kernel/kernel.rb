# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Kernel
==Rocinanteのコアプログラム
  Rocinanteの脳、感覚、記憶、行動プログラムを管理します。
=end

# Kernelクラス
module Rocinante
  class Kernel < TnaServer
    def initialize(server_name, notifier_unit, timer_span)
      # TnaServerクラスの初期化メソッドを呼び出す
      super

      # カーネルをロードする。
      load_kernel
    end

    # 定期的に実行されます。
    def execute(now_date)
      # 状態によって仕事をするか、夢を見ます。
      if(@brain.wakeup?) then
        work_action
      else
        dream_action
      end
    end

    # ろしなんてのカーネル情報を最新にします。
    def load_kernel
      # カーネルの各部品を読みなおす
      load $root[:kernel] + 'brain/brain.rb'
      load $root[:kernel] + 'body/body.rb'

      # 脳インスタンスを生成
      @brain  = Rocinante::Brain.new
      # 行動インスタンスを生成
      @body   = Rocinante::Body.new

      @log.info("カーネルのロードが完了しました。")
    end

    # 仕事をします
    def work_action
      # 考えた結果を記憶
      result = @brain.do_think({
        think_id: "Rocinante::TaskSelect",
        file_name: "task_select.rb"
      })

      # 思考に結果がエラーではなければ行動を行う
      if( result[:error] ) then
        puts result[:message]
      else
        puts result[:think]["ACTION_NAME"] + "を行います。"
        @body.do_action(result[:think])
      end

      # 寝る時間だったら睡眠判定を行います
      if( @brain.sleep? ) then
        # カーネルの再ロードを行います。
        load_kernel

        do_sleep
      end
    end

    # 夢を見ます
    def dream_action
      # 夢を見た結果を保存
      result = @brain.do_think({
        think_id: "Rocinante::DreamSelect",
        file_name: "dream_select.rb"
      })

      # 思考に結果がエラーではなければ行動を行う
      if( !result[:error] ) then
        @body.do_action(result)
      end

      # 起きる時間だったら起きます
      if(@brain.wakeup?) then
        # カーネルの再ロードを行います。
        load_kernel

        do_wakeup
      end
    end

    # ろしなんてを休憩します。
    def do_rest
      # ログを出力します。
      puts 'ろしなんてを休憩させます。'
      @body.do_rest
      @brain.do_rest

      # TnaServerのストップメソッドを呼び出す
      stop
    end
  end
end
