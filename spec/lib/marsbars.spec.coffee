marsbars = require '../../lib/marsbars.js'
_        = require 'underscore'

describe ".compileToHandlebars", ->

  examples = [
    [
      "single tag"
      """
      h1
      """
      '<h1></h1>'
    ]
    [
      "tag with class"
      """
      h1.main
      """
      '<h1 class="main"></h1>'
    ]
    [
      "tag with multiple classes"
      """
      h1.main.expanded
      """
      '<h1 class="main expanded"></h1>'
    ]
    [
      "tag with id and class"
      """
      h1#main.expanded
      """
      '<h1 id="main" class="expanded"></h1>'
    ]
    [
      "tag with class and id"
      """
      h1.main#expanded
      """
      '<h1 id="expanded" class="main"></h1>'
    ]
    [
      "just a class"
      """
      .main
      """
      '<div class="main"></div>'
    ]
    [
      "just multiple classes"
      """
      .main.expanded
      """
      '<div class="main expanded"></div>'
    ]
    [
      "just id and class"
      """
      #main.expanded
      """
      '<div id="main" class="expanded"></div>'
    ]
    [
      "just class and id"
      """
      .main#expanded
      """
      '<div id="expanded" class="main"></div>'
    ]
    [
      "just class and id with inline content"
      """
      .main#expanded Text
      """
      '<div id="expanded" class="main">Text</div>'
    ]

    [
      "tag with inline content"
      """
      h1 Title
      """
      '<h1>Title</h1>'
    ]
    [
      "nested content"
      """
      header
        h1
      """
      '<header><h1></h1></header>'
    ]
    [
      "nested tag w/ class"
      """
      header
        h1.main
      """
      '<header><h1 class="main"></h1></header>'
    ]
    [
      "nested tag w/ inline content"
      """
      header
        h1 Title
      """
      '<header><h1>Title</h1></header>'
    ]
    [
      "nested tags 2 deep"
      """
      header
        body
          h1 Title
      """
      '<header><body><h1>Title</h1></body></header>'
    ]
    [
      "outline content"
      """
      | Text
      """
      'Text'
    ]
    [
      "nested outline content"
      """
      div
        | Text
      """
      '<div>Text</div>'
    ]

    [
      "tag with attribute"
      """
      img(src="a.jpg")
      """
      '<img src="a.jpg"></img>'
    ]
    [
      "tag with attributes"
      """
      img( lang="en" version="4.0" )
      """
      '<img lang="en" version="4.0"></img>'
    ]
    [
      "inline HB content"
      """
      div= some.attribute
      """
      '<div>{{some.attribute}}</div>'
    ]
    [
      "outline HB content"
      """
      = some.attribute
      """
      '{{some.attribute}}'
    ]
    [
      "outline HB content w/ sibling element"
      """
      = some.attribute
      div other content
      """
      '{{some.attribute}}<div>other content</div>'
    ]
    [
      "inline unescaped HB content"
      """
      div== some.attribute
      """
      '<div>{{{some.attribute}}}</div>'
    ]
    [
      "outline unescaped HB content"
      """
      == some.attribute
      """
      '{{{some.attribute}}}'
    ]
    [
      "outline unescaped HB content"
      """
      == some.attribute
      div other content
      """
      '{{{some.attribute}}}<div>other content</div>'
    ]
    [
      "block HB"
      """
      - view and arguments
        div contents
      """
      '{{#view and arguments}}<div>contents</div>{{/view}}'
    ]
    [
      "if with else"
      """
      - if the.conditional
        div IF
      - else
        div ELSE
      """
      '{{#if the.conditional}}<div>IF</div>{{else}}<div>ELSE</div>{{/if}}'
    ]
    [
      "tag HB helper"
      """
      div{action edit} Content
      """
      "<div {{action edit}}>Content</div>"
    ]
    [
      "multiple tag HB helpers"
      """
      div{action edit}{bindAttr align="align"} Content
      """
      "<div {{action edit}}{{bindAttr align=\"align\"}}>Content</div>"
    ]
  ]

  indent = (markup)->
    "markup\n" + ("  " + line for line in markup.split(/\n/)).join "\n"

  _.each examples, ([title, marsbarsMarkup, expectedHandlebarsMarkup])->
    it "compiles #{title}", ->
      actualHandlebarsMarkup = marsbars.compileToHandlebars indent(marsbarsMarkup)

      expect( actualHandlebarsMarkup ).toEqual expectedHandlebarsMarkup
