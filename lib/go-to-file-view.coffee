editorHelpers = require 'path'
helpers = require './go-to-file-helpers'
FuzzyFinderView = do ->
  packagePath = atom.packages.resolvePackagePath 'fuzzy-finder'
  require path.join packagePath, 'lib', 'fuzzy-finder-view'

module.exports = class GoToFileView extends FuzzyFinderView
  toggle: ->
    if @panel?.isVisible()
      @cancel()
    else
      @goToFile()

  goToFile: ->
    editor = atom.workspace.getActiveTextEditor()
    paths = helpers.getPaths helpers.getPathToSearch editor
    if paths.length == 1
      @openPath paths[0]
    else if paths.length > 1
      @setItems paths
      @show()
