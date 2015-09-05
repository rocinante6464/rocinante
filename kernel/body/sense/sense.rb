# usr/bin/ruby
# coding:utf-8

=begin rdoc
=Sense
==Rocinanteの感覚プログラム
  Rocinanteは、外部からの依頼を受け取ることができます。
  SenseクラスではそのためのWebサーバを立ち上げます。
=end

module Rocinante
  # Senseクラス
  class Sense
    def initialize(memory)
      @memory = memory
    end

    def do_wait
      # コンフィグ設定
      config = {
        :ServerType => WEBrick::Daemon,
        :DocumentRoot => $rocinante_root + '/web',
      	:Port => 8099,
      }

      # 拡張子erbのファイルをERBを呼び出して処理するERBHandlerと関連付ける
      WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)

      # WEBrickのHTTP Serverクラスのサーバーインスタンスを作成する
      server = WEBrick::HTTPServer.new( config )

      # erbのMIMEタイプを設定
      server.config[:MimeTypes]["erb"] = "text/html"

      # 別プロセスでWebサーバを立ち上げます
      server.start
    end

    # 休みの指示が出た場合は以下の処理を行う
    def do_rest
      # フォークしたプロセスを削除する
      # ログを出力する
      Process.detach(@pid)
      Process.kill(:INT, @pid)
    end
  end
end
