window.Marsbars = require './marsbars.js'

window.MarsbarsEmber = window.MBE = {}

MarsbarsEmber.View = (markup)->
  { tag, handlebarsTemplate } = Marsbars.compile(markup)
  Em.View.extend
    template:   Em.Handlebars.compile(handlebarsTemplate)
    elementId:  tag.id
    tagName:    tag.tagName
    classNames: tag.classes
