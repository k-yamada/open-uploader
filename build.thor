# -*- coding: utf-8 -*-

require 'thor'
require 'shellutils'

class Build < Thor

  desc "build", "build"
  def build
    if ShellUtils.is_mac?
      ShellUtils.sh "./bin/build_linux.sh"
    else
      ShellUtils.sh "./bin/build_macos.sh"
    end
  end

end
