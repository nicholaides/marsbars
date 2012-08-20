_      = require 'underscore'
AST    = require '../../lib/ast.js'
parser = require '../../lib/marsbars.parser.js'

describe "Parser", ->
  describe "parsing tags", ->
    tags = [
      [ "h1"               , AST.Node("h1") ]
      [ "h1.main"          , AST.Node("h1", [AST.Class("main")]) ]
      [ "h1.main.expanded" , AST.Node("h1", [AST.Class("main"), AST.Class("expanded")]) ]
      [ "h1#main.expanded" , AST.Node("h1", [AST.Id("main"), AST.Class("expanded")]) ]
      [ "h1.main#expanded" , AST.Node("h1", [AST.Class("main"), AST.Id("expanded")]) ]
      [ ".main"            , AST.Node(null, [AST.Class("main")]) ]
      [ ".main.expanded"   , AST.Node(null, [AST.Class("main"), AST.Class("expanded")]) ]
      [ "#main.expanded"   , AST.Node(null, [AST.Id("main"), AST.Class("expanded")]) ]
      [ ".main#expanded"   , AST.Node(null, [AST.Class("main"), AST.Id("expanded")]) ]
      [ ".main#expanded Text"   , AST.Node(null, [AST.Class("main"), AST.Id("expanded")], [AST.TextNode("Text")]) ]

      [ "h1 Title", AST.Node("h1", [], [AST.TextNode("Title")])]
      [ "h1 Title of Article", AST.Node("h1", [], [AST.TextNode("Title of Article")])]
      [ "html\n  h1", AST.Node("html", [], [AST.Node("h1")])]
      [ "html\n  h1.main", AST.Node("html", [], [AST.Node("h1", [AST.Class("main")])])]
      [ "html\n  h1 Title", AST.Node("html", [], [AST.Node("h1", [], [AST.TextNode("Title")])])]
      [ "html\n  h1.main Title", AST.Node("html", [], [AST.Node("h1", [AST.Class("main")], [AST.TextNode("Title")])])]
      [ "html\n  body\n    h1 Title", AST.Node("html", [], [AST.Node("body", [], [AST.Node("h1", [], [AST.TextNode("Title")])])])]
      # [ "html\n  | Text", AST.Node("html", [], [AST.TextNode("Text")])]
    ]

    _.each tags, ([tagCode, expectedNode])->

      comparable = (node)->
        node.map (n)->
          tag           : n.getTagName?()
          classesAndIds : n.getClassesAndId?()
          text          : n.getText?()

      it "parses #{tagCode}", ->
        node = parser.parse(tagCode)
        expect( comparable(node) ).toEqual( comparable(expectedNode) )
