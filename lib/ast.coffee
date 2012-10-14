_ = require 'underscore'

class ASTNode
  setIndentLevel: (@_indentLevel)->
  getIndentLevel: -> @_indentLevel

  getParent: (n)->
    if n == 0
      @
    else
      debugger if !@parent
      @parent.getParent n-1

  setParent: (@parent)->

  setIndentation: (@indentation)-> @
  getIndentation: -> @indentation


class Node extends ASTNode
  setChildren: (children)->
    @children = []
    _.each children, (child)=> @addChild child
    @

  addChild: (child)->
    @children.push child
    child.setParent @

  getChildren: -> @children

  map: (callback)->
    [ callback(@), _.map(@children, (child)-> child.map(callback)) ]

  childrenHandlebars: -> ( child.toHandlebars() for child in @children ).join("")


class Element extends Node
  constructor: (tagName, classesAndId, children, attributes)->
    @attributesAndTagHelpers = []
    @setTagName tagName
    @setChildren children
    @setClassesAndId classesAndId
    @setAttributes attributes if attributes

  setIsRoot: ->
    @isRoot = true
    @

  setClassesAndId: (@classesAndId=[])-> @
  getClassesAndId: -> @classesAndId

  setTagName: (@tagName)-> @
  getTagName: -> @tagName

  setAttributesAndTagHelpers: (@attributesAndTagHelpers)-> @
  getAttributesAndTagHelpers: -> @attributesAndTagHelpers

  setAttributes: (attributes)->
    @attributesAndTagHelpers.push new AttributesList(attributes)

  compileTag: ->
    tag = {}
    tag.tagName = @tagName || 'div'

    attributesFromList = []
    for attributeListOrTagHelper in @attributesAndTagHelpers when attributeListOrTagHelper.getAttributes?
      for attribute in attributeListOrTagHelper.getAttributes()
        attributesFromList.push [attribute.getName(), attribute.getValue()]

    ids = []
    ids.push classOrId.getId() for classOrId in @classesAndId when classOrId.getId?
    tag.id = ids[ids.length-1] if ids.length > 0

    classes = []
    classes.push classOrId.getClassName() for classOrId in @classesAndId when classOrId.getClassName?
    tag.classes = classes

    tag.attributes = []
    for [attName, attValue] in attributesFromList
      tag.attributes.push [attName, attValue] unless attName in ['id', 'class']

    tag


  toHandlebars: ->
    if @isRoot
      @childrenHandlebars()
    else
      tag = @compileTag()

      attributes = tag.attributes.slice()
      attributes.unshift ['class', tag.classes.join(" ")] if tag.classes.length
      attributes.unshift ['id', tag.id] if tag.id?

      attributesHTML = ( "#{name}=\"#{value}\"" for [name, value] in attributes ).join(" ")
      tagHelpersHTML = ( helper.toTagHelperHandlebars() for helper in @attributesAndTagHelpers when helper.toTagHelperHandlebars? ).join("")

      html = "<#{tag.tagName}"
      html += " " + attributesHTML unless attributesHTML == ""
      html += " " + tagHelpersHTML unless tagHelpersHTML == ""
      html += ">"
      html += @childrenHandlebars()
      html += "</#{tag.tagName}>"

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

class AttributesList
  constructor: (@attributes)->
  getAttributes: -> @attributes

exports.AttributesList = (args...)-> new AttributesList args...

class TextNode extends Node
  constructor: (@text)->
  toHandlebars: -> @text
  setChildren: -> throw "Invalid AST Construction"

exports.TextNode = (args...)-> new TextNode args...


class HBContent extends ASTNode
  constructor: (@content)->
  map: (callback)-> callback @
  toHandlebars: -> "{{#{@content}}}"

exports.HBContent = (args...)-> new HBContent args...

class HBTagHelper
  constructor: (@content)->
  toTagHelperHandlebars: -> "{{#{@content}}}"


exports.HBTagHelper = (args...)-> new HBTagHelper args...

class HBContentUnescaped extends HBContent
  toHandlebars: -> "{{{#{@content}}}}"

exports.HBContentUnescaped = (args...)-> new HBContentUnescaped args...


class HBBlock extends Node
  constructor: (@helperMethod, @arguments, children)->
    @setChildren children

  toHandlebars: ->
    "{{##{@helperMethod} #{@arguments}}}#{ @childrenHandlebars() }{{/#{@helperMethod}}}"

exports.HBBlock = (args...)-> new HBBlock args...


class HBElse extends HBContent
  constructor: ->
    @content = "else"

  getIndentLevel: -> super() + 1

exports.HBElse = (args...)-> new HBElse args...




exports.cleanInput = (input)->
  lines = input.split "\n"
  lines = _.filter lines, (line)-> !line.match /^\s*$/
  lines = _.map lines,    (line)-> line.replace /\s+$/, ''
  lines.join("\n") + "\n"

exports.getIndentation = (input)->
  input.match(/^\s*/)[0]

setIndentLevels = (root, elements)->
  root.setIndentLevel 0

  indentStyle = null

  _.each elements, (element)->
    console.log(element) unless element.getIndentation?
    indentation = element.getIndentation()
    if indentation == ""
      element.setIndentLevel 0
    else
      indentStyle ?= new RegExp indentation, "g"
      element.setIndentLevel indentation.match(indentStyle).length

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
    indentDifference = previousElement.getIndentLevel() - element.getIndentLevel() + 1

    throw "Indenting too far" if indentDifference < 0

    previousElement.getParent(indentDifference).addChild element

    previousElement = element

  root

