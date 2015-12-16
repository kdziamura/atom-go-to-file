{CompositeDisposable} = require 'atom'
GoToFileView = require './go-to-file-view'

module.exports =
  goToFileView: null
  subscriptions: null

  config:
    autoOpenSingleResult:
      default: true
      type: 'boolean'
      description: 'Don\'t show list if it is single file in results. Automatically navigate to it.'

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'go-to-file:toggle': => @getGoToFileView().toggle()

  getGoToFileView: ->
    unless @goToFileView?
      @goToFileView = new GoToFileView
    @goToFileView

  deactivate: ->
    if @subscriptions
      @subscriptions.dispose()
      @subscriptions = null

    if @goToFileView?
      @goToFileView.destroy()
      @goToFileView = null
