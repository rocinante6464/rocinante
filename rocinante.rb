# usr/bin/ruby
# coding:utf-8

=begin rdoc
@author:TATSUKI SATO
=Rocinante
==「Rocinanteプロジェクト」について
  Rocinanteは、人間が行う作業の一部を担う人工知能プログラムである。
  RocinanteプロジェクトはRocinanteを開発・管理・運用していくプロジェクトである。
  担う作業としては以下のものが挙げられる。
  * ツイートによる組織の宣伝
  * タスクのリマインダー通知
  * アフィリエイトによる収入の確立　など

=end

# グローバル変数（ろしなんての各ルートディレクトリ）
$root = Hash.new
$root[:rocinante] = File.expand_path('../', __FILE__) + "/"
$root[:kernel] = $root[:rocinante] + "kernel/"
$root[:memory] = $root[:kernel]    + "brain/memory/"
$root[:mind]   = $root[:kernel]    + "brain/mind/"
$root[:think]  = $root[:kernel]    + "brain/think/"
$root[:action] = $root[:kernel]    + "body/action/"
$root[:log]    = $root[:rocinante] + "log/"
$root[:etc]    = $root[:rocinante] + "etc/"

$rocinante_root = File.expand_path('../', __FILE__) + "/"
$kernel_root = $rocinante_root + "kernel/"
$memory_root = $kernel_root    + "brain/memory/"
$mind_root   = $kernel_root    + "brain/mind/"
$think_root  = $kernel_root    + "brain/think/"
$action_root = $kernel_root    + "body/action/"
$log_root    = $rocinante_root + "log/"
$etc_root    = $rocinante_root + "etc/"

# 日付フォーマット
$DATE_FORMAT = "%Y-%m-%d %H:%M:%S"

# Rocinante
module Rocinante
  # 外部ライブラリ読み込む
  require "logger"
  require "sqlite3"
  require "webrick"
  require "erb"
  require "arrayfields"
  require "systemu"
  require "twitter"
  require "openssl"
  require "yaml"

  # 内部ライブラリ読み込み
  require $root[:rocinante] + "lib/tna_server/tna_server.rb"
  require $root[:rocinante] + "lib/twitter/twitter_client.rb"

  # 内部ベースクラスを読み込み
  require $root[:action]    + "base/action_base.rb"

  # 核プログラムを読み込み
  require $root[:kernel]    + 'kernel.rb'
end

begin
  # ろしなんてシステムを起動します。
  rocinante = Rocinante::Kernel.new("RocinanteKernel", "SECOND", 10)

  # Ctrl-C割り込みがあった場合にろしなんてをメンテナンスモードに以降する
  trap(:INT) do
    puts 'ろしなんては寝る支度をはじめました。zzz'
    rocinante.do_rest
  end

  rocinante.start
rescue
  puts $!
end
