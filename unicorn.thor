# -*- coding: utf-8 -*-

require 'thor'
require 'shellutils'

class Unicorn < Thor
  desc "start", 'unicorn start'
  def start
    #ShellUtils.sh "bundle exec unicorn -c config/unicorn.rb -E #{Libs::ConfigUtils.get_rails_env} -D"
    env  = ENV['OPEN_UPLOADER_ENV']  || "production"
    port = ENV['OPEN_UPLOADER_PORT'] || 8080
    ShellUtils.sh "bundle exec unicorn -c config/unicorn.rb -E #{env} -p #{port} -D"
  end

  desc "stop", 'Graceful shutdown (Send signal QUIT to master process).'
  def stop
    send_signal_to_unicorn(unicorn_pid, :QUIT)
  end

  desc "graceful_restart", "graceful restart"
  def graceful_restart
    if unicorn_pid
      send_signal_to_unicorn(unicorn_pid,     :USR2)
      send_signal_to_unicorn(unicorn_old_pid, :WINCH)
      send_signal_to_unicorn(unicorn_pid,     :QUIT)
    else
      invoke :start
    end
  end

  desc "restart", 'restart'
  def restart
    send_signal_to_unicorn(unicorn_pid, :HUP)
  end

  private

  def unicorn_pid
    `cat /tmp/open-uploader.pid`
  end

  def unicorn_old_pid
    `cat /tmp/open-uploader.pid.oldbin`
  end

  def send_signal_to_unicorn(pid, signal, failed_message='Not running.')
    if pid
      ShellUtils.sh "kill -#{signal.to_s} #{pid}"
    else
      puts failed_message if failed_message.present?
    end
  end
end
