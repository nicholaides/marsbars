(function() {
  var parser, _;

  _ = require('underscore');

  parser = require('../../lib/marsbars.parser.js');

  describe("Parser", function() {
    it("parses nested tags", function() {
      var text;
      text = "html\n  head\n    meta\n  body\n    header\n    footer";
      return parser.parse(text);
    });
    describe("node", function() {
      return it(function() {
        parser.parse("h1 Marsbars For Dummies");
        parser.parse("h1");
        return parser.parse("h1  ");
      });
    });
    return describe("parsing tags", function() {
      var tags;
      tags = [
        [
          "h1", {
            tag: {
              name: "h1",
              classesAndId: []
            }
          }
        ], [
          "h1.main", {
            tag: {
              name: "h1",
              classesAndId: [
                {
                  className: "main"
                }
              ]
            }
          }
        ], [
          "h1.main.expanded", {
            tag: {
              name: "h1",
              classesAndId: [
                {
                  className: "main"
                }, {
                  className: "expanded"
                }
              ]
            }
          }
        ], [
          "h1#main.expanded", {
            tag: {
              name: "h1",
              classesAndId: [
                {
                  id: "main"
                }, {
                  className: "expanded"
                }
              ]
            }
          }
        ], [
          "h1.main#expanded", {
            tag: {
              name: "h1",
              classesAndId: [
                {
                  className: "main"
                }, {
                  id: "expanded"
                }
              ]
            }
          }
        ], [
          ".main", {
            tag: {
              classesAndId: [
                {
                  className: "main"
                }
              ]
            }
          }
        ], [
          ".main.expanded", {
            tag: {
              classesAndId: [
                {
                  className: "main"
                }, {
                  className: "expanded"
                }
              ]
            }
          }
        ], [
          "#main.expanded", {
            tag: {
              classesAndId: [
                {
                  id: "main"
                }, {
                  className: "expanded"
                }
              ]
            }
          }
        ], [
          ".main#expanded", {
            tag: {
              classesAndId: [
                {
                  className: "main"
                }, {
                  id: "expanded"
                }
              ]
            }
          }
        ]
      ];
      _.each(tags, function(_arg) {
        var expectedNode, tagCode;
        tagCode = _arg[0], expectedNode = _arg[1];
        expectedNode.children = [];
        return it("parses " + tagCode, function() {
          var node;
          node = parser.parse(tagCode);
          return expect(node).toEqual(expectedNode);
        });
      });
      parser.parse("h1");
      parser.parse("h1.main");
      parser.parse("h1.main.expanded");
      parser.parse("h1#main.expanded");
      parser.parse("h1.main#expanded");
      parser.parse(".main");
      parser.parse(".main.expanded");
      parser.parse("#main.expanded");
      return parser.parse(".main#expanded");
    });
  });

}).call(this);
