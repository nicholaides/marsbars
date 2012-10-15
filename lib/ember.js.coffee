window.Marsbars = require './marsbars.js'

window.MarsbarsEmber = window.MBE =
  TEMPLATES_MARKUP: {}

  compileView: (markup)->
    { tag, handlebarsTemplate } = Marsbars.compile(markup)
    Em.View.extend
      template:   Em.Handlebars.compile(handlebarsTemplate)
      elementId:  tag.id
      tagName:    tag.tagName
      classNames: tag.classes

  getView: (templateName)->
    MBE.compileView MBE.TEMPLATES_MARKUP[templateName]
