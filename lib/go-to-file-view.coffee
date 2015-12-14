fs = require 'fs'
path = require 'path'
packagePath = atom.packages.resolvePackagePath('fuzzy-finder')
FuzzyFinderView = require path.join(packagePath, 'lib', 'fuzzy-finder-view')

module.exports = class GoToFileView extends FuzzyFinderView
  toggle: ->
    if @panel?.isVisible()
      @cancel()
    else
      paths = @getFiles()
      if paths.length == 1
        atom.workspace.open paths[0]
      else if paths.length > 1
        @setItems paths
        @show()

  getFilesInDirectory: (dirname, filter) ->
    fs.readdirSync(dirname)?.reduce (files, filename) ->
      fullPath = path.join dirname, filename

      if fs.statSync(fullPath).isFile()
        if not filter? or filter? fullPath
          files = files.concat fullPath

      return files
    , []

  getPath: (editor) ->
    selected = editor.getSelectedText()
    if not selected
      range = editor.bufferRangeForScopeAtCursor '.string.quoted'
      selected = if range then editor.getTextInBufferRange(range)[1...-1] else null
    selected

  getFiles: ->
    files = []
    editor = atom.workspace.getActiveTextEditor()
    pathToSearch = @getPath editor

    if not pathToSearch?
      return files

    currentDir = path.dirname editor.getPath()
    fullPath =  path.join currentDir, pathToSearch

    try
      stats = fs.statSync fullPath
      if stats.isFile()
        files = [fullPath]
      else if stats.isDirectory()
        files = @getFilesInDirectory fullPath
    catch e
      files = @getFilesInDirectory path.dirname(fullPath), (fileFullPath) ->
        fileFullPath.search(fullPath) != -1
    finally
      return files
