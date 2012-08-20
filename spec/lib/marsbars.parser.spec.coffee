_      = require 'underscore'
AST    = require '../../lib/ast.js'
parser = require '../../lib/marsbars.parser.js'

describe "Parser", ->
  describe "parsing tags", ->
    tags = [
      [ "h1"               , AST.Element("h1") ]
      [ "h1.main"          , AST.Element("h1", [AST.Class("main")]) ]
      [ "h1.main.expanded" , AST.Element("h1", [AST.Class("main"), AST.Class("expanded")]) ]
      [ "h1#main.expanded" , AST.Element("h1", [AST.Id("main"), AST.Class("expanded")]) ]
      [ "h1.main#expanded" , AST.Element("h1", [AST.Class("main"), AST.Id("expanded")]) ]
      [ ".main"            , AST.Element(null, [AST.Class("main")]) ]
      [ ".main.expanded"   , AST.Element(null, [AST.Class("main"), AST.Class("expanded")]) ]
      [ "#main.expanded"   , AST.Element(null, [AST.Id("main"), AST.Class("expanded")]) ]
      [ ".main#expanded"   , AST.Element(null, [AST.Class("main"), AST.Id("expanded")]) ]
      [ ".main#expanded Text"   , AST.Element(null, [AST.Class("main"), AST.Id("expanded")], [AST.TextNode("Text")]) ]

      [ "h1 Title", AST.Element("h1", [], [AST.TextNode("Title")])]
      [ "h1 Title of Article", AST.Element("h1", [], [AST.TextNode("Title of Article")])]
      [ "html\n  h1", AST.Element("html", [], [AST.Element("h1")])]
      [ "html\n  h1.main", AST.Element("html", [], [AST.Element("h1", [AST.Class("main")])])]
      [ "html\n  h1 Title", AST.Element("html", [], [AST.Element("h1", [], [AST.TextNode("Title")])])]
      [ "html\n  h1.main Title", AST.Element("html", [], [AST.Element("h1", [AST.Class("main")], [AST.TextNode("Title")])])]
      [ "html\n  body\n    h1 Title", AST.Element("html", [], [AST.Element("body", [], [AST.Element("h1", [], [AST.TextNode("Title")])])])]
      [ "html\n  | Text", AST.Element("html", [], [AST.TextNode("Text")])]
    ]

    _.each tags, ([tagCode, expectedElement])->

      comparable = (element)->
        element.map (node)->
          tag           : node.getTagName?()
          classesAndIds : node.getClassesAndId?()
          text          : node.getText?()

      it "parses #{tagCode}", ->
        element = parser.parse(tagCode)
        expect( comparable(element) ).toEqual( comparable(expectedElement) )
