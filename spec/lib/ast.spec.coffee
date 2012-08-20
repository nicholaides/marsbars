_      = require 'underscore'
AST    = require '../../lib/ast.js'

describe "cleanInput", ->
  it "removes trailing whitespace from input", ->
    input = "html  \nend\n"
    expectedOutput = "html\nend"

    output = AST.cleanInput input

    expect(output).toEqual(expectedOutput)

  it "removes blank lines from input", ->
    input = "html  \n  \n  \nend  \n  \n  \n  "
    expectedOutput = "html\nend"

    output = AST.cleanInput input

    expect(output).toEqual(expectedOutput)

  it "retains indentation", ->
    input = "html\n  end"
    expectedOutput = "html\n  end"

    output = AST.cleanInput input

    expect(output).toEqual(expectedOutput)

describe "treeifyNodes", ->
  treeByTagName = (node)->
    node.map (n)-> n.getTagName()

  describe "given a tree with one node", ->
    it "just return the node", ->
      node = AST.Node 'html'
      expectedTree = ['html', []]

      tree = AST.treeifyNodes node, []
      resultTree = treeByTagName tree

      expect(resultTree).toEqual expectedTree

  describe "given a tree with 2 nodes", ->
    it "returns the correct tree", ->
      html = AST.Node('html').setIndentation("")
      head = AST.Node('head').setIndentation("  ")

      expectedTree = ["html",[ ["head",[ ]] ]]

      tree = AST.treeifyNodes html, [head]
      resultTree = treeByTagName tree

      expect(resultTree).toEqual expectedTree


  it "makes a tree out of their indentations and order", ->
    expectedTree =
      AST.Node 'html', [], [
        AST.Node 'head', [], [
          AST.Node 'meta', []
        ]
        AST.Node 'body', [], [
          AST.Node 'header', []
          AST.Node 'footer', []
        ]
      ]
    expectedTree = treeByTagName expectedTree

    nodes = [
      AST.Node('html'  ).setIndentation(""),
      AST.Node('head'  ).setIndentation("  "),
      AST.Node('meta'  ).setIndentation("    "),
      AST.Node('body'  ).setIndentation("  "),
      AST.Node('header').setIndentation("    "),
      AST.Node('footer').setIndentation("    ")
    ]

    [root, rest...] = nodes
    resultTree = treeByTagName AST.treeifyNodes root, rest

    expect( resultTree ).toEqual expectedTree

describe "Node", ->
  describe "map", ->
    describe "on a single node", ->
      it "returns a tuple of the result and an empty array for children", ->
        result = AST.Node("blink").map (node)-> node.getTagName()
        expect(result).toEqual ["blink", []]

    describe "with a whole tree", ->
      it "maps over the tree of nodes", ->
        nodes =
          AST.Node 'html', [], [
            AST.Node 'head', [], [
              AST.Node 'meta', []
            ]
            AST.Node 'body', [], [
              AST.Node 'header', []
              AST.Node 'footer', []
            ]
          ]

        tagNames = nodes.map (node)-> node.getTagName()

        expectedTagNames =
          ['html', [
              ['head', [
                  ['meta', []]
              ]],
              ['body', [
                  ['header', []],
                  ['footer', []]
              ]]
          ]]


        expect( tagNames ).toEqual expectedTagNames


  describe "addChild", ->

    it "appends it to its list of children", ->
      parent = AST.Node()
      child  = AST.Node()
      child2 = AST.Node()

      parent.addChild child
      parent.addChild child2

      expect( parent.getChildren() ).toEqual [child, child2]

    it "sets the childs' parent to itself", ->
      parent = AST.Node()
      child  = AST.Node()
      parent.addChild child

      expect( child.getParent(1) ).toEqual parent

  describe "parent(n)", ->

    describe "given 0", ->
      n = 0
      it "returns itself", ->
        node = AST.Node()
        expect( node.getParent(n) ).toEqual node

    describe "given n", ->
      n = 2
      it "returns the right parent", ->
        parent          = AST.Node()
        child           = AST.Node()
        grandchild      = AST.Node()
        greatgrandchild = AST.Node()

        parent     .addChild child
        child      .addChild grandchild
        grandchild .addChild greatgrandchild

        expect( greatgrandchild.getParent(n) ).toEqual child
