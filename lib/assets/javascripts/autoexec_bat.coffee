$ = jQuery
$.fn.extend
  autoexec: (options) ->
    return @each -> AutoexecBat.run $(@).data('autoexec')


window.AutoexecBat =
  topLevel: "App"
  debug: true
  autoRequire: null
        
  log: (msg) ->
    console?.log msg if AutoexecBat.debug

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
    top    = AutoexecBat.topLevel #window
    target = AutoexecBat.namespace name

    target.name     = name
    target.loaded   = false
    target.autoexec = -> # make sure the autoexec function exists
    target.dependencies = dependencies
    target.init     = -> 
      unless @loaded 
        require dependencies
        @autoexec() if typeof @autoexec is 'function'
        @autoexec = -> AutoexecBat.log "Module already initialized"
        @loaded = true

    block target, top 

  require: (dependencies) ->
    (AutoexecBat.initializeModule(lib) for lib in dependencies) if dependencies

  namespace: (name) ->
    target = window
    target = target[item] or= {} for item in name.split '.'
    target

  findModule: (ns) ->
    return unless ns
    ns = ns.split "." if typeof ns is "string"
    ns.unshift AutoexecBat.topLevel unless ns[0] == AutoexecBat.topLevel

    module = window
    for item in ns
      module = module[item] unless typeof module[item] is 'undefined'
    module

  initializeModule: (nameOrModule) ->
    module = if typeof nameOrModule is "string" then AutoexecBat.findModule(nameOrModule) else nameOrModule
    module.init() if typeof module isnt 'undefined' and typeof module.init isnt 'undefined'

  run: (name) ->
    module = AutoexecBat.findModule name
    AutoexecBat.initializeModule module


# Globals
window.define = AutoexecBat.define
window.require= AutoexecBat.require
window.Namespace= AutoexecBat.namespace
