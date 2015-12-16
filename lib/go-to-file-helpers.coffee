fs = require 'fs-plus'
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
      pathToSearch = path.resolve currentDir, selected

    pathToSearch

  getFilesInDirectory: (dirname) ->
    paths = []

    if fs.isDirectorySync dirname
      paths = fs.readdirSync dirname;
      paths = _.map paths, (filename) -> path.join dirname, filename
      paths = _.filter paths, (fullPath) -> fs.isFileSync fullPath

    paths

  getSimilarFilenames: (pathToSearch) ->
    paths = @getFilesInDirectory path.dirname pathToSearch
    paths = _.filter paths, (fileFullPath) -> _.startsWith fileFullPath, pathToSearch

  getPaths: (pathToSearch) ->
    paths = []

    if pathToSearch?
      if fs.isFileSync pathToSearch
        paths = [pathToSearch]
      else if fs.isDirectorySync pathToSearch
        paths = @getFilesInDirectory pathToSearch
      else
        paths = @getSimilarFilenames pathToSearch

    paths
