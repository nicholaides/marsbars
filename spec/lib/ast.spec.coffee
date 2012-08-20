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

describe "treeifyElements", ->
  treeByTagName = (element)->
    element.map (n)-> n.getTagName()

  describe "given a tree with one element", ->
    it "just return the element", ->
      element = AST.Element 'html'
      expectedTree = ['html', []]

      tree = AST.treeifyElements element, []
      resultTree = treeByTagName tree

      expect(resultTree).toEqual expectedTree

  describe "given a tree with 2 elements", ->
    it "returns the correct tree", ->
      html = AST.Element('html').setIndentation("")
      head = AST.Element('head').setIndentation("  ")

      expectedTree = ["html",[ ["head",[ ]] ]]

      tree = AST.treeifyElements html, [head]
      resultTree = treeByTagName tree

      expect(resultTree).toEqual expectedTree


  it "makes a tree out of their indentations and order", ->
    expectedTree =
      AST.Element 'html', [], [
        AST.Element 'head', [], [
          AST.Element 'meta', []
        ]
        AST.Element 'body', [], [
          AST.Element 'header', []
          AST.Element 'footer', []
        ]
      ]
    expectedTree = treeByTagName expectedTree

    elements = [
      AST.Element('html'  ).setIndentation(""),
      AST.Element('head'  ).setIndentation("  "),
      AST.Element('meta'  ).setIndentation("    "),
      AST.Element('body'  ).setIndentation("  "),
      AST.Element('header').setIndentation("    "),
      AST.Element('footer').setIndentation("    ")
    ]

    [root, rest...] = elements
    resultTree = treeByTagName AST.treeifyElements root, rest

    expect( resultTree ).toEqual expectedTree

describe "Element", ->
  describe "map", ->
    describe "on a single element", ->
      it "returns a tuple of the result and an empty array for children", ->
        result = AST.Element("blink").map (element)-> element.getTagName()
        expect(result).toEqual ["blink", []]

    describe "with a whole tree", ->
      it "maps over the tree of elements", ->
        elements =
          AST.Element 'html', [], [
            AST.Element 'head', [], [
              AST.Element 'meta', []
            ]
            AST.Element 'body', [], [
              AST.Element 'header', []
              AST.Element 'footer', []
            ]
          ]

        tagNames = elements.map (element)-> element.getTagName()

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
      parent = AST.Element()
      child  = AST.Element()
      child2 = AST.Element()

      parent.addChild child
      parent.addChild child2

      expect( parent.getChildren() ).toEqual [child, child2]

    it "sets the childs' parent to itself", ->
      parent = AST.Element()
      child  = AST.Element()
      parent.addChild child

      expect( child.getParent(1) ).toEqual parent

  describe "parent(n)", ->

    describe "given 0", ->
      n = 0
      it "returns itself", ->
        element = AST.Element()
        expect( element.getParent(n) ).toEqual element

    describe "given n", ->
      n = 2
      it "returns the right parent", ->
        parent          = AST.Element()
        child           = AST.Element()
        grandchild      = AST.Element()
        greatgrandchild = AST.Element()

        parent     .addChild child
        child      .addChild grandchild
        grandchild .addChild greatgrandchild

        expect( greatgrandchild.getParent(n) ).toEqual child
