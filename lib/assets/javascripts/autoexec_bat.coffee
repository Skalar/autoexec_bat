AutoexecBat =
  topLevel: "App"
  debug: false
  autoRequire: false

  log: (msg) ->
    console?.log msg if AutoexecBat.debug

  require: (dependencies) ->
    (AutoexecBat.initializeModule(lib) for lib in dependencies) if dependencies

  define: (name) ->
    dependencies = []
    dependencies.push AutoexecBat.autoRequire if AutoexecBat.autoRequire && name != AutoexecBat.autoRequire

    for arg in arguments
      if typeof arg is "object"
        for module in arg
          dependencies.push module unless module in dependencies && module != name

      else if typeof arg is "function"
        block = arg

    block ?= -> # empty function
    top    = AutoexecBat.topLevel
    target = AutoexecBat.namespace name

    target.name     = name
    target.loaded   = false
    target.autoexec = -> # make sure the autoexec function exists
    target.dependencies = dependencies
    target.init     = (options) ->
      options or=
        idempotent: false
        callee: null

      unless options.idempotent and @loaded
        AutoexecBat.require dependencies
        @autoexec(options.callee) if typeof @autoexec is 'function'
        if options.idempotent
          @autoexec = -> AutoexecBat.log "Module already initialized"
        @loaded = true

    block target, top

  namespace: (name) ->
    target = root
    target = target[item] or= {} for item in name.split '.'
    target

  findModule: (ns) ->
    return unless ns
    ns = ns.split "." if typeof ns is "string"
    ns.unshift AutoexecBat.topLevel unless ns[0] == AutoexecBat.topLevel

    module = root
    for item in ns
      module = module[item] unless typeof module[item] is 'undefined'
    module

  initializeModule: (nameOrModule, options) ->
    module = if typeof nameOrModule is "string" then AutoexecBat.findModule(nameOrModule) else nameOrModule
    module.init(options) if typeof module isnt 'undefined' and typeof module.init isnt 'undefined'

  run: (name, options) ->
    module = AutoexecBat.findModule name
    AutoexecBat.initializeModule module, options


# Globals
root = exports ? window
root.AutoexecBat = AutoexecBat
root.define      = AutoexecBat.define
root.require     = AutoexecBat.require
root.namespace   = AutoexecBat.namespace

# Plugins
unless typeof jQuery is 'undefined'
  $ = jQuery
  $.fn.extend
    autoexec: (options) ->
      options = $.extend
        callee: @
        idempotent: true
      , options
      return @each -> AutoexecBat.run $(@).data('autoexec'), options
