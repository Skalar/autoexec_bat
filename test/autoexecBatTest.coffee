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
        exports.autoexec = -> "do something"

    it "defines a function", ->
      autoexec.App.Foo.autoexec().should.equal "do something"

    it "can be executed", ->
      autoexec.AutoexecBat.run('App.Foo').should.equal true

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

      it "autoRequired modules are automatically loaded"


  describe "require", ->
    beforeEach ->
      autoexec.define 'App.Foo', (exports) ->
        exports.autoexec = -> "do something"

    it "loads the modules"

    it "ignores undefined modules", ->
      autoexec.require(["App.BareFoot"])

    it "ignores empty argument", ->
      autoexec.require()
