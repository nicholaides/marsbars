parser = require './marsbars.parser.js'

module.exports =
  compileToHandlebars: (marsbarsMarkup)->
    parser.parse(marsbarsMarkup).toHandlebars()
