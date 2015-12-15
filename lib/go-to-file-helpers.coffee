fs = require 'fs'
path = require 'path'
_ = require 'lodash'

module.exports =
  getPathToSearch: (editor) ->
    pathToSearch = null
    selected = editor.getSelectedText()

    unless selected
      range = editor.bufferRangeForScopeAtCursor '.string.quoted'
      if range
        selected = editor.getTextInBufferRange(range)[1...-1]

    if selected
      currentDir = path.dirname editor.getPath()
      pathToSearch = path.join currentDir, selected

    pathToSearch

  getFilesInDirectory: (dirname) ->
    paths = []

    try
      paths = fs.readdirSync dirname;
      paths = _.map paths, (filename) -> path.join dirname, filename
      paths = _.filter paths, (fullPath) -> fs.statSync(fullPath).isFile()
    catch e

    paths

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
        paths = @getFilesInDirectory path.dirname pathToSearch
        paths = _.filter paths, (fileFullPath) -> _.startsWith fileFullPath, pathToSearch

    paths
