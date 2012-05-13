module AutoexecBat
  module Helper

    def default_autoexec_module
      candidates = controller.controller_path.split('/') << controller.action_name
      # candidates.unshift "shared" if candidates.length == 2
      candidates.map &:camelcase
    end

    def autoexec_module(name=nil)
      @autoexec_module = name if name
      @autoexec_module || default_autoexec_module
    end

  end
end
