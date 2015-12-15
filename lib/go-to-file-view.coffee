fs = require 'fs'
path = require 'path'
_ = require 'lodash'
packagePath = atom.packages.resolvePackagePath 'fuzzy-finder'
FuzzyFinderView = require path.join(packagePath, 'lib', 'fuzzy-finder-view')

module.exports = class GoToFileView extends FuzzyFinderView
  toggle: ->
    if @panel?.isVisible()
      @cancel()
    else
      @goToFile()

  goToFile: ->
    editor = atom.workspace.getActiveTextEditor()
    paths = @getPaths(@getPathToSearch editor)
    if paths.length == 1
      @openPath paths[0]
    else if paths.length > 1
      @setItems paths
      @show()

  getFilesInDirectory: (dirname) ->
    paths = []

    try
      paths = fs.readdirSync dirname;
      paths = _.map paths, (filename) -> path.join dirname, filename
      paths = _.filter paths, (fullPath) -> fs.statSync(fullPath).isFile()
    catch e

    paths

  getPathToSearch: (editor) ->
    pathToSearch = null
    selected = editor.getSelectedText()

    if not selected
      range = editor.bufferRangeForScopeAtCursor '.string.quoted'
      selected = if range then editor.getTextInBufferRange(range)[1...-1] else null

    if selected
      currentDir = path.dirname editor.getPath()
      pathToSearch = path.join currentDir, selected

    pathToSearch

  getPaths: (pathToSearch) ->
    paths = []

    if pathToSearch?
      try
        stats = fs.statSync pathToSearch
        if stats.isFile()
          paths = [pathToSearch]
        else if stats.isDirectory()
          paths = @getFilesInDirectory pathToSearch
      catch e
        paths = @getFilesInDirectory path.dirname(pathToSearch)
        paths = _.filter paths, (fileFullPath) -> _.startsWith fileFullPath, pathToSearch

    paths
