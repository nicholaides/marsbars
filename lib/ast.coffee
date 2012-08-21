_ = require 'underscore'

class Element
  constructor: (tagName, classesAndId, children)->
    @setTagName tagName
    @setChildren children
    @setClassesAndId classesAndId

  setIsRoot: ->
    @isRoot = true
    @

  setChildren: (children)->
    @children = []
    _.each children, (child)=> @addChild child
    @

  setClassesAndId: (@classesAndId=[])-> @
  getClassesAndId: -> @classesAndId

  setTagName: (@tagName)-> @
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

  setAttributes: (@attributes)-> @
  getAttributes: ()-> @attributes


  map: (callback)->
    [ callback(@), _.map(@children, (child)-> child.map(callback)) ]

  toHandlebars: ->
    tagName = @tagName || 'div'

    attributes = []

    ids = []
    ids.push classOrId.getId()    for classOrId in @classesAndId when classOrId.getId?
    ids.push attribute.getValue() for attribute in @attributes   when attribute.getName() == 'id'
    attributes.push ['id', ids[ids.length-1]] if ids.length > 0

    classes = []
    classes.push classOrId.getClassName() for classOrId in @classesAndId when classOrId.getClassName?
    classes.push attribute.getValue()     for attribute in @attributes   when attribute.getName() == 'class'
    attributes.push ['class', classes.join(' ')] if classes.length > 0

    attributes.unshift [attribute.getName(), attribute.getValue()] for attribute in @attributes when attribute.getName() not in ['id', 'class']

    childrenHandlebars = ( child.toHandlebars() for child in @children ).join("")

    if @isRoot
      childrenHandlebars = ( child.toHandlebars() for child in @children ).join("")
    else
      attributesHTML = ( "#{name}=\"#{value}\"" for [name, value] in attributes ).join(" ")

      html = "<#{tagName}"
      html += " " + attributesHTML if attributesHTML.length > 0

      if @children.length == 0
        html += " />"
      else
        html += ">"
        html += childrenHandlebars
        html += "</#{tagName}>"

      html

exports.Element = (args...)-> new Element args...

class Class
  constructor: (@className)->
  getClassName: -> @className

exports.Class = (args...)-> new Class args...


class Id
  constructor: (@idName)->
  getId: -> @idName

exports.Id = (args...)-> new Id args...


class Attribute
  constructor: (@attName, @attValue)->
  getName:  -> @attName
  getValue: -> @attValue

exports.Attribute = (args...)-> new Attribute args...



class TextNode
  constructor: (@text)->

  setParent: (@parent)->

  getText: -> @text

  map: (callback)-> callback @

  setIndentation: (@indentation)-> @
  getIndentation: ()-> @indentation

  toHandlebars: ->
    @text


exports.TextNode = (args...)-> new TextNode args...


exports.cleanInput = (input)->
  lines = input.split "\n"
  lines = _.filter lines, (line)-> !line.match /^\s*$/
  lines = _.map lines,    (line)-> line.replace /\s+$/, ''
  lines.join "\n"

exports.getIndentation = (input)->
  input.match(/^\s*/)[0]

setIndentLevels = (root, elements)->
  root.indentLevel = 0

  indentStyle = null

  _.each elements, (element)->
    console.log(element) unless element.getIndentation?
    indentation = element.getIndentation()
    if indentation == ""
      element.indentLevel = 0
    else
      indentStyle ?= new RegExp indentation, "g"
      element.indentLevel = indentation.match(indentStyle).length

# previous element's parent

#                    |        | Previous | Previous
#                    | Indent | Indent   | Element's
# Markup             | Level  | Level    | Parent
#===================================================
# html               | 0      |          |
#   head             | 1      | 0        | 0
#     meta           | 2      | 1        | 0
#   body             | 1      | 2        | 2
#     container      | 2      | 1        | 0
#     othercontainer | 2      | 2        | 0
exports.treeifyElements = (root, subElements)->
  setIndentLevels root, subElements

  previousElement = root

  _.each subElements, (element)->
    indentDifference = previousElement.indentLevel - element.indentLevel + 1

    throw "Indenting too far" if indentDifference < 0

    previousElement.getParent(indentDifference).addChild element

    previousElement = element

  root

