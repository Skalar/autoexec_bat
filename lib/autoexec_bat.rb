require "autoexec_bat/version"
require "autoexec_bat/helper"

module AutoexecBat

  module Rails
    class Engine < ::Rails::Engine
      ActionView::Base.send :include, AutoexecBat::Helper
    end
  end
end
