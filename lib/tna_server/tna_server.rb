#encoding: utf-8
# 通知を受け取るサーバクラス
#  Author:: Tatsuki Sato
#  Date::   2015/02/25
#======================================
require 'date'
require 'logger'
require File.dirname(__FILE__) + '/common/notifier_factory'

# TNAサーバクラス
class TnaServer
  NOT_OVERRRIDE = 'NotOverRideError'

  # コンストラクタ
  # @param [String] server_name サーバ名
  # @param [String] notifier 配信者の種類
  # @param [Numeric] execSpan 実行スパン
  def initialize(server_name, notifier_unit, timer_span)
    @log = Logger.new($log_root + "kernel.log")
    # サーバ名
    @server_name = server_name
    # 配信者クラスを生成
    @notifier = NotifierFactory::create_notifier(notifier_unit)
    # 実行感覚
    @timer_span = timer_span
  end

  # 通知を受け取った場合にスレッドで処理を実行
  def update(now_date)
    # スレッドに処理を投げる
    execThread = Thread.new do
      # 処理を行う
      execute(now_date)
    end
  end

  # サーバの処理
  def execute(now_date)
    raise TnaServer::NOT_OVERRRIDE
  end

  # サーバの起動
  def start
    @log.info(@server_name + " を開始します。")

    # タイマーを指定のスパンでスタートする
    @notifier.start_timer(@timer_span, self)
  end

  # サーバの停止
  def stop
    # タイマーをストップする。
    @notifier.stop_timer

    @log.info(@server_name + " を停止します。")
  end
end
