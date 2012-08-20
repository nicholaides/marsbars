_      = require 'underscore'
AST    = require '../../lib/ast.js'
parser = require '../../lib/marsbars.parser.js'

describe "Parser", ->
  describe "parsing tags", ->
    tags = [
      [
        "h1"
        AST.Element "h1"
      ]
      [
        "h1.main"
        AST.Element "h1", [
          AST.Class "main"
        ]
      ]
      [
        "h1.main.expanded"
        AST.Element "h1", [
          AST.Class "main"
          AST.Class "expanded"
        ]
      ]
      [
        "h1#main.expanded"
        AST.Element "h1", [
          AST.Id "main"
          AST.Class "expanded"
        ]
      ]
      [
        "h1.main#expanded"
        AST.Element "h1", [
          AST.Class "main"
          AST.Id "expanded"
        ]
      ]
      [
        ".main"
        AST.Element null, [
          AST.Class "main"
        ]
      ]
      [
        ".main.expanded"
        AST.Element null, [
          AST.Class "main"
          AST.Class "expanded"
        ]
      ]
      [
        "#main.expanded"
        AST.Element null, [
          AST.Id "main"
          AST.Class "expanded"
        ]
      ]
      [
        ".main#expanded"
        AST.Element null, [
          AST.Class "main"
          AST.Id "expanded"
        ]
      ]
      [
        ".main#expanded Text"
        AST.Element null, [AST.Class("main"), AST.Id("expanded")], [
          AST.TextNode("Text")
        ]
      ]
      [
        "h1 Title"
        AST.Element "h1", [], [
          AST.TextNode "Title"
        ]
      ]
      [
        "h1 Title of Article"
        AST.Element "h1", [], [
          AST.TextNode "Title of Article"
        ]
      ]
      [
        """
        html
          h1
        """
        AST.Element "html", [], [
          AST.Element "h1"
        ]
      ]
      [
        """
        html
          h1.main
        """
        AST.Element "html", [], [
          AST.Element "h1", [
            AST.Class "main"
          ]
        ]
      ]
      [
        """
        html
          h1 Title
        """
        AST.Element "html", [], [
          AST.Element "h1", [], [
            AST.TextNode "Title"
          ]
        ]
      ]
      [
        """
        html
          h1.main Title
        """
        AST.Element "html", [], [
          AST.Element "h1", [AST.Class("main")], [
            AST.TextNode "Title"
          ]
        ]
      ]
      [
        """
        html
          body
            h1 Title
        """
        AST.Element "html", [], [
          AST.Element "body", [], [
            AST.Element "h1", [], [
              AST.TextNode "Title"
            ]
          ]
        ]
      ]
      [
        """
        html
          | Text
        """
        AST.Element "html", [], [
          AST.TextNode "Text"
        ]
      ]

      [
        "html(lang=\"en\")"
        AST.Element "html", [], [], [AST.Attribute('lang', 'en')]
      ]
      [
        "html( lang=\"en\" version=\"4.0\" )"
        AST.Element "html", [], [], [
          AST.Attribute 'lang', 'en'
          AST.Attribute 'version', '4.0'
        ]
      ]
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
