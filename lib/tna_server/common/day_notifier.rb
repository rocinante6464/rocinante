#encoding: utf-8
# 時間を毎時間通知するクラス
#  Author:: Tatsuki Sato
#  Date::   2015/03/04

require File.dirname(__FILE__) + '/time_notifier'

# 毎日現在時刻を監視者に通知するクラス
class DayNotifier < TimeNotifier
  # 毎日監視者に時間を通知する
  # @observe [Date] DateTime 現在時刻
  def time_notify(timerSpan)
    # stop_timerメソッドが呼ばれるまでループ
    while @active do
      # 更新通知を行う
      changed
      # 監視者にパラメータを送信
      notify_observers(Time.now)     
      # 現在時刻と次の通知時間
      now = Time.now
      exe = Time.local(now.year, now.month, now.day, 0, 0, 0, 0) + (timerSpan * 60 * 60 * 24)
      # 次の通知時間までスレッドをスリープさせる
      sleep (exe - now).to_f
    end
  end
end
