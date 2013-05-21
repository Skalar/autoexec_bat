chai = require 'chai'
jack = require 'jack'

chai.use jack.chai
should = chai.should()
expect = chai.expect

autoexec = require '../lib/assets/javascripts/autoexec_bat'

describe 'AutoexecBat', ->

  describe "global variables", ->
    it "should define AutoexecBat", -> autoexec.AutoexecBat.should.be.a 'object'
    it "should have a define function", -> autoexec.define.should.be.a 'function'
    it "should have a require function", -> autoexec.require.should.be.a 'function'
    it "should have a namespace function", -> autoexec.namespace.should.be.a 'function'

  describe "namespace", ->

    it "declares function namespaces", ->
      autoexec.namespace('App.Foo.Bar').should.equal autoexec.App.Foo.Bar
      autoexec.namespace('App.Foo').should.equal autoexec.App.Foo
      autoexec.namespace('App.Foo').should.be.a 'object'

  describe "define", ->
    beforeEach ->
      autoexec.define 'App.Foo', (exports) ->
        exports.autoexec = ->
          "do something"

        privateMethod = ->
          'I am hidden'

    it "defines a function that can be called", ->
      autoexec.App.Foo.autoexec().should.equal "do something"

    it "can be executed", ->
      autoexec.AutoexecBat.run('App.Foo').should.equal true

    it "private methods are unavailable", ->
      expect(autoexec.App.Foo.privateMethod).to.not.be.ok

    it "should not be loaded", ->
      autoexec.App.Foo.loaded.should.equal false

    describe "dependencies", ->
      it "should be empty when not defined", ->
        autoexec.App.Foo.dependencies.should.be.empty

      it "can be specified", ->
        autoexec.define 'App.Bar', ["App.Foo"], (exports) ->
        autoexec.App.Bar.dependencies.should.deep.equal(["App.Foo"])

      it "ignores non-existing dependencies", ->
        autoexec.define 'App.Bar', ["App.Bullshit"], (exports) ->
        autoexec.App.Bar.dependencies.should =~ ['App.Bullshit']

    describe "autoRequire", ->

      it "should be disabled by default", ->
        autoexec.AutoexecBat.autoRequire.should.not.be.ok
        autoexec.App.Foo.dependencies.should.be.empty

      it "autoRequired modules are automatically added to the dependency list", ->
        autoexec.AutoexecBat.autoRequire = "App.Always"
        autoexec.define "App.Bar", -> exports.autoexec = -> 'something here'
        autoexec.App.Bar.dependencies.should.include "App.Always"

    it "has support for idempotency"

    it "knows the callee"

  describe "require", ->
    beforeEach ->
      autoexec.define 'App.Foo', (exports) ->
        exports.autoexec = -> "do something"

    it "loads the modules"

    it "ignores undefined modules", ->
      autoexec.require(["App.BareFoot"])

    it "ignores empty argument", ->
      autoexec.require()
