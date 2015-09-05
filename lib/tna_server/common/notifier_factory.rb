#encoding: utf-8
# 通知クラスのファクトリークラス
#  Author:: Tatsuki Sato
#  Date::   2015/02/25
#======================================
require File.dirname(__FILE__) + '/second_notifier'
require File.dirname(__FILE__) + '/minutes_notifier'
require File.dirname(__FILE__) + '/hour_notifier'
require File.dirname(__FILE__) + '/day_notifier'

# 配信者生成クラス
module NotifierFactory
  # 配信者定義
  @notifiers = {
    "SECOND"  => SecondNotifier,
    "MINUTES" => MinutesNotifier,
    "HOUR"    => HourNotifier,
    "DAY"     => DayNotifier
  }.freeze

  # 配信者クラスを生成するメソッド
  def self.create_notifier(notifierUnit)
    # 配信スパンを設定してサーバ実行
     return @notifiers[notifierUnit].new(notifierUnit)
  end
end
