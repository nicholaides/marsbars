_ = require 'underscore'

class Node
  constructor: (tagName, classesAndId, children)->
    @setTagName tagName
    @setChildren children
    @setClassesAndId classesAndId

  setChildren: (@children=[])-> @
  setContents: (@contents=[])-> @

  setClassesAndId: (@classesAndId=[])-> @
  getClassesAndId: -> @classesAndId

  setTagName: (@tagName)-> @
  setContent: (@content)-> @
  setIndentation: (@indentation)->
    @indentation || ""
    @

  addChild: (child)->
    @children.push child
    child.setParent @

  getTagName: -> @tagName

  getChildren: -> @children

  getIndentation: -> @indentation

  getParent: (n)->
    if n == 0
      @
    else
      @parent.getParent n-1

  setParent: (@parent)->

  map: (callback)->
    [ callback(@), _.map(@children, (child)-> child.map(callback)) ]

exports.Node = (args...)-> new Node args...


class Class
  constructor: (@className)->

exports.Class = (args...)-> new Class args...


class Id
  constructor: (@idName)->

exports.Id = (args...)-> new Id args...



class ContentNode
  constructor: (@content)->

exports.ContentNode = (args...)-> new ContentNode args...


exports.cleanInput = (input)->
  lines = input.split "\n"
  lines = _.filter lines, (line)-> !line.match /^\s*$/
  lines = _.map lines,    (line)-> line.replace /\s+$/, ''
  lines.join "\n"

exports.getIndentation = (input)->
  input.match(/^\s*/)[0]

setIndentLevels = (root, nodes)->
  root.indentLevel = 0

  indentStyle = null

  _.each nodes, (node)->
    indentation = node.getIndentation()
    if indentation == ""
      node.indentLevel = 0
    else
      indentStyle ?= new RegExp indentation, "g"
      node.indentLevel = indentation.match(indentStyle).length

# previous node's parent

#                    |        | Previous | Previous
#                    | Indent | Indent   | Node's
# Markup             | Level  | Level    | Parent
#===================================================
# html               | 0      |          |
#   head             | 1      | 0        | 0
#     meta           | 2      | 1        | 0
#   body             | 1      | 2        | 2
#     container      | 2      | 1        | 0
#     othercontainer | 2      | 2        | 0
exports.treeifyNodes = (root, subNodes)->
  setIndentLevels root, subNodes

  previousNode = root

  _.each subNodes, (node)->
    indentDifference = previousNode.indentLevel - node.indentLevel + 1

    throw "Indenting too far" if indentDifference < 0

    previousNode.getParent(indentDifference).addChild node

    previousNode = node

  root

