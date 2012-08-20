_      = require 'underscore'
AST    = require '../../lib/ast.js'
parser = require '../../lib/marsbars.parser.js'

describe "Parser", ->
  describe "parsing tags", ->
    tags = [
      [ "h1"               , AST.Node("h1") ],
      [ "h1.main"          , AST.Node("h1", [AST.Class("main")]) ],
      [ "h1.main.expanded" , AST.Node("h1", [AST.Class("main"), AST.Class("expanded")]) ],
      [ "h1#main.expanded" , AST.Node("h1", [AST.Id("main"), AST.Class("expanded")]) ],
      [ "h1.main#expanded" , AST.Node("h1", [AST.Class("main"), AST.Id("expanded")]) ],
      [ ".main"            , AST.Node(null, [AST.Class("main")]) ],
      [ ".main.expanded"   , AST.Node(null, [AST.Class("main"), AST.Class("expanded")]) ],
      [ "#main.expanded"   , AST.Node(null, [AST.Id("main"), AST.Class("expanded")]) ],
      [ ".main#expanded"   , AST.Node(null, [AST.Class("main"), AST.Id("expanded")]) ]
    ]

    _.each tags, ([tagCode, expectedNode])->
      expectedNode.children = []

      grab = (node)->
        tag: node.getTagName()
        classesAndIds: node.getClassesAndId()

      it "parses #{tagCode}", ->
        node = parser.parse(tagCode)
        expect( grab(node) ).toEqual( grab(expectedNode) )
