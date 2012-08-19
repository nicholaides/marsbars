_ = require 'underscore'
parser = require '../../lib/marsbars.parser.js'

describe "Parser", ->
  it "parses nested tags", ->
    text = """
      html
        head
          meta
        body
          header
          footer
    """
    parser.parse(text)


  describe "node", ->
    it ->
      parser.parse "h1 Marsbars For Dummies"
      parser.parse "h1"
      parser.parse "h1  "


  describe "parsing tags", ->
    tags = [
      [ "h1"               , { tag: { name: "h1", classesAndId: [] } } ],
      [ "h1.main"          , { tag: { name: "h1", classesAndId: [{className: "main"}] } } ],
      [ "h1.main.expanded" , { tag: { name: "h1", classesAndId: [{className: "main"}, {className: "expanded"}] } } ],
      [ "h1#main.expanded" , { tag: { name: "h1", classesAndId: [{id: "main"}, {className: "expanded"}] } } ],
      [ "h1.main#expanded" , { tag: { name: "h1", classesAndId: [{className: "main"}, {id: "expanded"}] } } ],
      [ ".main"            , { tag: {             classesAndId: [{className: "main"}] } } ],
      [ ".main.expanded"   , { tag: {             classesAndId: [{className: "main"}, {className: "expanded"}] } } ],
      [ "#main.expanded"   , { tag: {             classesAndId: [{id: "main"}, {className: "expanded"}] } } ],
      [ ".main#expanded"   , { tag: {             classesAndId: [{className: "main"}, {id: "expanded"}] } } ],
    ]

    _.each tags, ([tagCode, expectedNode])->
      expectedNode.children = []

      it "parses #{tagCode}", ->
        node = parser.parse(tagCode)
        expect( node ).toEqual( expectedNode )

    parser.parse "h1"
    parser.parse "h1.main"
    parser.parse "h1.main.expanded"
    parser.parse "h1#main.expanded"
    parser.parse "h1.main#expanded"
    parser.parse ".main"
    parser.parse ".main.expanded"
    parser.parse "#main.expanded"
    parser.parse ".main#expanded"


