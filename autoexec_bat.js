// Generated by CoffeeScript 1.6.2
(function() {
  var $, AutoexecBat, root,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  AutoexecBat = {
    topLevel: "App",
    debug: false,
    autoRequire: false,
    log: function(msg) {
      if (AutoexecBat.debug) {
        return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
      }
    },
    require: function(dependencies) {
      var lib, _i, _len, _results;

      if (dependencies) {
        _results = [];
        for (_i = 0, _len = dependencies.length; _i < _len; _i++) {
          lib = dependencies[_i];
          _results.push(AutoexecBat.initializeModule(lib));
        }
        return _results;
      }
    },
    define: function(name) {
      var arg, block, dependencies, module, target, top, _i, _j, _len, _len1;

      dependencies = [];
      if (AutoexecBat.autoRequire && name !== AutoexecBat.autoRequire) {
        dependencies.push(AutoexecBat.autoRequire);
      }
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        arg = arguments[_i];
        if (typeof arg === "object") {
          for (_j = 0, _len1 = arg.length; _j < _len1; _j++) {
            module = arg[_j];
            if (!(__indexOf.call(dependencies, module) >= 0 && module !== name)) {
              dependencies.push(module);
            }
          }
        } else if (typeof arg === "function") {
          block = arg;
        }
      }
      if (block == null) {
        block = function() {};
      }
      top = AutoexecBat.topLevel;
      target = AutoexecBat.namespace(name);
      target.name = name;
      target.loaded = false;
      target.autoexec = function() {};
      target.dependencies = dependencies;
      target.init = function(options) {
        options || (options = {
          idempotent: false,
          callee: null
        });
        if (!(options.idempotent && this.loaded)) {
          AutoexecBat.require(dependencies);
          if (typeof this.autoexec === 'function') {
            this.autoexec(options.callee);
          }
          if (options.idempotent) {
            this.autoexec = function() {
              return AutoexecBat.log("Module already initialized");
            };
          }
          return this.loaded = true;
        }
      };
      return block(target, top);
    },
    namespace: function(name) {
      var item, target, _i, _len, _ref;

      target = root;
      _ref = name.split('.');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        target = target[item] || (target[item] = {});
      }
      return target;
    },
    findModule: function(ns) {
      var item, module, _i, _len;

      if (!ns) {
        return;
      }
      if (typeof ns === "string") {
        ns = ns.split(".");
      }
      if (ns[0] !== AutoexecBat.topLevel) {
        ns.unshift(AutoexecBat.topLevel);
      }
      module = root;
      for (_i = 0, _len = ns.length; _i < _len; _i++) {
        item = ns[_i];
        if (typeof module[item] !== 'undefined') {
          module = module[item];
        }
      }
      return module;
    },
    initializeModule: function(nameOrModule, options) {
      var module;

      module = typeof nameOrModule === "string" ? AutoexecBat.findModule(nameOrModule) : nameOrModule;
      if (typeof module !== 'undefined' && typeof module.init !== 'undefined') {
        return module.init(options);
      }
    },
    run: function(name, options) {
      var module;

      module = AutoexecBat.findModule(name);
      return AutoexecBat.initializeModule(module, options);
    }
  };

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.AutoexecBat = AutoexecBat;

  root.define = AutoexecBat.define;

  root.require = AutoexecBat.require;

  root.namespace = AutoexecBat.namespace;

  if (typeof jQuery !== 'undefined') {
    $ = jQuery;
    $.fn.extend({
      autoexec: function(options) {
        options = $.extend({
          callee: this,
          idempotent: true
        }, options);
        return this.each(function() {
          return AutoexecBat.run($(this).data('autoexec'), options);
        });
      }
    });
  }

}).call(this);
