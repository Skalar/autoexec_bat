# AutoexecBat

AutoexecBat was written to aid organizing and running javascript code using the Rails asset pipeline.

The main idea is to organize all javascript code into separate namespaces and let a data-autoexec attribute determine which module to run.

Some examples:

    define "App.Products", (exports) ->
        exports.autoexec = ->
            # this is the autoexec function that AutoexecBat looks for

    # Module with private methods
    define "App.Products.Index", (exports) ->
        exports.autoexec = ->
            setupEventListeners()
            setupSomethingElse()
            takeItAway()

        setupEventListeners = ->
            $('table tbody td').on 'click', -> # event handler
            $('input').on 'click', -> # another event handler

        takeItAway = ->
            $('tag').doSomething()

        setupSomethingElse = ->
            $('.private').show()

    # A module with dependencies
    define "App.Products.Show", ["App.Products"], (exports) ->
        exports.autoexec = ->
            # this module has a dependency to App.Products,
            # which will be executed first

    # If all you want is to run the dependencies:
    define "App.Gallery", ["App.UI.Fancybox", "App.UI.FileUpload"]

    # A simple coffeescript class:
    class namespace("App.Models").Product
        # this class will be known as App.Models.Product

    # Run AutoexecBat on all tags with a data-autoexec attribute (using jQuery)
    jQuery ->
        $('[data-autoexec]').autoexec()

    # If you're using the jQuery plugin you can fetch the callee in the autoexec function
    define "App.Products.Show", (exports) ->
        exports.autoexec = (productItem) ->
            setupEventListeners(productItem)

        setupEventListeners = (productItem) ->
            $(productItem).on 'click', -> # specific event handler

    # y u no got jquery?
    # Run it manually or use whatever
    AutoexecBat.run "App.Products.Show"
    # or
    App.Products.Show.autoexec()

    # To push the callee to autoexec
    AutoexecBat.run "App.Products.Show", productItem
    # or
    App.Products.Show.autoexec(productItem)

    # If you want modules to be autoexec'd several times
    App.Products.Show.autoexec
        idempotent: false

Finally, just add the module name to a data-autoexec attribute:

    <body data-autoexec="App.Products.Index">

If the given module doesn't exist, it tries to execute a parent module.
In this case, App.Products.autoexec() will be executed:

    <div data-autoexec="App.Products.Dev.Null">..</div>

### Auto-require

If you have a module that you want to be included always, you can instruct AutoexecBat to require it:

    AutoexecBat.autoRequire = "App.My.Module"

Note: this will only work with modules defined with define().

## Installation

Add this line to your application's Gemfile:

    gem 'autoexec_bat'

Require your modules and activate autoexecution (with turbolinks - default in Rails 4):

    #= require autoexec_bat
    #= require_tree ./folder-containing-your-modules
    jQuery(document).bind 'ready page:load', ->
        $('[data-autoexec]').autoexec
            idempotent: false

For Rails 3:

    #= require autoexec_bat
    #= require_tree ./folder-containing-your-modules
    jQuery ->
        $('[data-autoexec]').autoexec()

## Testing

Install mocha and chai:

    # npm install -g mocha coffee-script
    # npm install chai jack

And run the test suite:

    # mocha -R spec --watch     (or)
    # rake test

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
