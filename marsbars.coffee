_ = require 'underscore'

class LineNodeable
  constructor: ->
    @children = []

  add: (child)->
    @children.push child
    child.setParent @


class LineNode extends LineNodeable
  constructor: (@line, @lineNumber)->
    super()

  parent: (n)->
    if n == 0
      @
    else
      @_parent.parent n-1

  setParent: (node)->
    @_parent = node

  indentLevel: ->
    @line.match(/^(  )*/g)[0].length / 2

  lineCode: ->
    @line.trim()

  toArrayTree: ->
    [ @lineCode(), _.invoke(@children, 'toArrayTree') ]

class RootNodesContainer extends LineNodeable
  indentLevel: -> -1

  toArrayTree: ->
    _.invoke @children, 'toArrayTree'

  parent: (n)->
    throw "Call to parent should always be 0, but was #{n}" if n != 0
    @

exports.lineTree = (text)->

  rootContainer = previousNode = new RootNodesContainer

  lines = text.split /\n/

  lineNodes = _.map lines, (line, lineNumber)-> new LineNode line, lineNumber

  _.each lineNodes, (lineNode)->
    indentDifference = previousNode.indentLevel() - lineNode.indentLevel() + 1

    if indentDifference < 0
      throw "Indenting too far on line #{lineNumber}"

    previousNode.parent(indentDifference).add lineNode

    previousNode = lineNode

  rootContainer

exports.LineNode = LineNode
exports.RootNodesContainer = RootNodesContainer
