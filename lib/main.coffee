{CompositeDisposable} = require 'atom'
GoToFileView = require './go-to-file-view'

module.exports =
  goToFileView: null
  subscriptions: null

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
