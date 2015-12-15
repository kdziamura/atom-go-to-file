GoToFileView = require './go-to-file-view'

module.exports =
  goToFileView: null

  activate: (state) ->
    atom.commands.add 'atom-workspace',
      'go-to-file:toggle': => @getGoToFileView().toggle()

  getGoToFileView: ->
    unless @goToFileView?
      @goToFileView = new GoToFileView
    @goToFileView

  deactivate: ->
    if @goToFileView?
      @goToFileView.destroy()
      @goToFileView = null
