marsbars = require './marsbars.coffee'
LineNode = marsbars.LineNode
RootNodesContainer = marsbars.RootNodesContainer


describe "lineTree", ->
  text = """
    html
      head
        meta
        meta
      body
        header text
        article text
  """

  it "takes a string and breaks it into a string of lines", ->
    tree = marsbars.lineTree text
    expectedTree = [
      ["html",
        [
          ["head",
            [
              ["meta", []],
              ["meta", []],
            ]
          ],
          ["body",
            [
              ["header text", []],
              ["article text", []],
            ]
          ]
        ]
      ]
    ]

    expect(tree.toArrayTree()).toEqual expectedTree

describe "LineNode", ->
  describe "parent(n)", ->

    describe "given 0", ->
      n = 0
      it "returns itself", ->
        lineNode = new LineNode
        parent = lineNode.parent(0)
        expect(parent).toEqual lineNode

    describe "given n", ->
      n = 2
      it "returns the right parent", ->
        parent = new LineNode
        child = new LineNode
        grandchild = new LineNode
        greatgrandchild = new LineNode

        parent.add child
        child.add grandchild
        grandchild.add greatgrandchild

        expect( greatgrandchild.parent(2) ).toEqual child



  describe "indentLevel", ->

    describe "with no indentation", ->
      lineNode = new LineNode "html"
      it "returns 0", ->
        expect( lineNode.indentLevel() ).toEqual 0

    describe "with 4 spaces", ->
      lineNode = new LineNode "    html"
      it "returns 2", ->
        expect( lineNode.indentLevel() ).toEqual 2

  describe "lineCode", ->
    it "returns just the code on the line without whitespace on either end", ->
      lineNode = new LineNode "  html code    "
      expect( lineNode.lineCode() ).toEqual "html code"

  describe "toArrayTree", ->
    describe "of a single node", ->
      it "returns its line code an empty list of children", ->
        lineNode = new LineNode "  html code  "
        expect( lineNode.toArrayTree() ).toEqual ["html code", []]

    describe "of a whole tree", ->
      it "returns an array representation of the tree", ->
          parent = new LineNode "parent"
          child = new LineNode "child"
          grandchild = new LineNode "grandchild"
          othergrandchild = new LineNode "othergrandchild"
          greatgrandchild = new LineNode "greatgrandchild"

          parent.add child
          child.add grandchild
          child.add othergrandchild
          grandchild.add greatgrandchild

          arrayTree = parent.toArrayTree()
          expectedTree =
            ["parent",
              [
                ["child",
                  [
                    ["grandchild",
                      [
                        ["greatgrandchild", []]
                      ]
                    ],
                    ["othergrandchild", []]
                  ]
                ]
              ]
            ]

          expect( arrayTree ).toEqual expectedTree

describe "RootNodesContainer", ->
  describe "#toArrayTree", ->
    it "returns a list of its childrens' trees", ->
      container = new RootNodesContainer
      node1 = new LineNode "node1"
      node2 = new LineNode "node2"
      container.add node1
      container.add node2

      tree = container.toArrayTree()

      expectedTree = [
        ["node1", []],
        ["node2", []],
      ]

      expect( tree ).toEqual expectedTree
