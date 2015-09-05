#encoding: utf-8
# 時間の通知者基底クラス
#  Author:: Tatsuki Sato
#  Date::   2015/03/02
#======================================
require 'date'
require 'logger'
require 'observer'

# 現在時刻を監視者に通知するクラス
class TimeNotifier
  include Observable
  NOT_OVERRRIDE = 'NotOverRideError'

  # コンストラクタ
  # @param [String] notifier 通知者名
  # @param [Integer] execSpan 実行スパン
  # @param [Object] observer 監視者
  def initialize(notifier)
    # 通知者名
    @notifier = notifier
    # ロガーのインスタンスを生成
    @log = Logger.new($rocinante_root + "/log/kernel.log")
  end

  # 通知者による時間の監視を開始
  def start_timer(timerSpan, observer)
    # 通知があった時に通知する先を定義
    add_observer(observer)
    # ログを設定
    @log.info("NOTIFIER:" << @notifier.to_s << " TIMER_SPAN:" << timerSpan.to_s << " >> START")
    # 通知者の実行状態
    @active = true
    # 時間の監視を開始
    time_notify(timerSpan)
  end

  # 通知者による時間の監視を停止
  def stop_timer
    # 通知者をストップする
    @active = false
    # ログを出力する
    @log.info("NOTIFIER:" << @notifier.to_s << " >> STOP")
  end

  # 監視者に時間を通知
  def time_notify
    raise TimeNotifier::NOT_OVERRRIDE
  end
end
