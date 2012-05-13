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
        

    jQuery ->
        # Run AutoexecBat on all tags with a data-autoexec attribute
        $('[data-autoexec]').autoexec()

Finally, just add the module name to a data-autoexec attribute:

    <body data-autoexec="App.Products.Index">
        
If the given module doesn't exist, it tries to execute a parent module.
In this case, the module App.Products.autoexec() will be executed:

    <div data-autoexec="App.Products.Dev.Null">..</div>
    

## Installation

Add this line to your application's Gemfile:

    gem 'autoexec_bat'

Require your modules and activate autoexecution:

    #= require autoexec_bat
    #= require_tree ./folder-containing-your-modules
    jQuery ->
        $('[data-autoexec]').autoexec()


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
