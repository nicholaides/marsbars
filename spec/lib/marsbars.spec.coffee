marsbars = require '../../lib/marsbars.js'
_        = require 'underscore'

describe ".compileToHandlebars", ->

  examples = [
    [
      'h1'
      '<h1></h1>'
    ]
    [
      'h1.main'
      '<h1 class="main"></h1>'
    ]
    [
      'h1.main.expanded'
      '<h1 class="main expanded"></h1>'
    ]
    [
      'h1#main.expanded'
      '<h1 id="main" class="expanded"></h1>'
    ]
    [
      'h1.main#expanded'
      '<h1 id="expanded" class="main"></h1>'
    ]
    [
      '.main'
      '<div class="main"></div>'
    ]
    [
      '.main.expanded'
      '<div class="main expanded"></div>'
    ]
    [
      '#main.expanded'
      '<div id="main" class="expanded"></div>'
    ]
    [
      '.main#expanded'
      '<div id="expanded" class="main"></div>'
    ]
    [
      '.main#expanded Text'
      '<div id="expanded" class="main">Text</div>'
    ]
    [
      'h1 Title'
      '<h1>Title</h1>'
    ]
    [
      """
      html
        h1
      """
      '<html><h1></h1></html>'
    ]
    [
      """
      html
        h1.main
      """
      '<html><h1 class="main"></h1></html>'
    ]
    [
      """
      html
        h1 Title
      """
      '<html><h1>Title</h1></html>'
    ]
    [
      """
      html
        body
          h1 Title
      """
      '<html><body><h1>Title</h1></body></html>'
    ]
    [
      """
      html
        | Text
      """
      '<html>Text</html>'
    ]

    [
      'html(lang="en")'
      '<html lang="en"></html>'
    ]
    [
      'html( lang="en" version="4.0" )'
      '<html lang="en" version="4.0"></html>'
    ]
    [
      'html= some.attribute'
      '<html>{{some.attribute}}</html>'
    ]
    [
      """
      html
        = some.attribute
      """
      '<html>{{some.attribute}}</html>'
    ]
    [
      """
      html
        = some.attribute
        div other content
      """
      '<html>{{some.attribute}}<div>other content</div></html>'
    ]
    [
      'html== some.attribute'
      '<html>{{{some.attribute}}}</html>'
    ]
    [
      """
      html
        == some.attribute
      """
      '<html>{{{some.attribute}}}</html>'
    ]
    [
      """
      html
        == some.attribute
        div other content
      """
      '<html>{{{some.attribute}}}<div>other content</div></html>'
    ]
    [
      """
      html
        - view and arguments
          div contents
      """
      '<html>{{#view and arguments}}<div>contents</div>{{/view}}</html>'
    ]
    [
      """
      html
        - if the.conditional
          div IF
        - else
          div ELSE
      """
      '<html>{{#if the.conditional}}<div>IF</div>{{else}}<div>ELSE</div>{{/if}}</html>'
    ]
    [
      """
      html
        div{action edit} Content
      """
      "<html><div {{action edit}}>Content</div></html>"
    ]
  ]

  indent = (markup)->
    "markup\n" + ("  " + line for line in markup.split(/\n/)).join "\n"

  _.each examples, ([marsbarsMarkup, expectedHandlebarsMarkup])->
    it "compiles #{marsbarsMarkup}", ->
      actualHandlebarsMarkup = marsbars.compileToHandlebars indent(marsbarsMarkup)

      expect( actualHandlebarsMarkup ).toEqual expectedHandlebarsMarkup
