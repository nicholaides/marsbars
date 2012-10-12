// If we're in Element, require the AST module. Otherwise, assume it's been include in the page
{
  if (require) AST = require('./ast');

  input = AST.cleanInput(input);
}
template
  = root:rootElement nonRootNodes:nonRootNode*
  { return AST.treeifyElements(root, nonRootNodes); }

rootElement
  = element:element [\n]
  { return element.setIsRoot(); }

nonRootNode
  = indentation:whitespace node:node [\n]
  { return node.setIndentation(indentation.join('')); }

node = element / hbElseBlock / hbBlock / outlineTextNode / outlineHBContent

element = tagWithInlineContent / tagWithNoInlineContent

tagWithNoInlineContent
  = tag:tag { return tag; }

tagWithInlineContent
  = tag:tag contentNode:inlineContentNode
  {
    tag.addChild(contentNode);
    return tag;
  }

hbBlock
  = '-' whitespace helperChars:[a-z0-9]i+ whitespace argumentsChars:[^\n]*
  { return AST.HBBlock(helperChars.join(''), argumentsChars.join('')); }

hbElseBlock
  = '-' whitespace "else"
  { return AST.HBElse(); }

tag
  = tag:tagBase attributes:attributes?
  { return tag.setAttributes(attributes); }

tagBase
  = tagName:tagName classesAndId:classOrId* { return AST.Element(tagName, classesAndId); }
  / classesAndId:classOrId+                 { return AST.Element(null,    classesAndId); }

tagName
  = chars:[a-z0-9]i+ { return chars.join(''); }

classOrId = className / idName

className
  = '.' chars:[a-z0-9]i+ { return AST.Class(chars.join('')); }

idName
  = '#' chars:[a-z0-9]i+ { return AST.Id(chars.join('')); }

attributes
  = '(' atts:attributeList ')' { return atts; }

attributeList
  = whitespace attribute:attribute moreAttributes:secondAttribute* whitespace
  {
    var allAtts = moreAttributes.slice();
    allAtts.push(attribute);
    return allAtts;
  }

attribute
  = name:attributeName '=' value:attributeValue { return AST.Attribute(name, value); }

attributeName
  = chars:[a-z0-9]i+ { return chars.join(''); }

attributeValue
  = '"' chars:[^"]* '"' { return chars.join(''); }

secondAttribute
  = [ \t]+ attribute:attribute { return attribute; }

inlineContentNode
  = [ \t]+ textNode:inlineTextNode     { return textNode; }
  / "=" whitespace hbContent:hbContent { return hbContent; }

hbContent
  = chars:[^\n]* { return AST.HBContent(chars.join('')); }

inlineTextNode = textNode

outlineTextNode =
  "|" whitespace textNode:textNode { return textNode; }

outlineHBContent =
  "=" whitespace hbContent:hbContent { return hbContent; }

textNode
  = text:[^\n]+ { return AST.TextNode(text.join('')); }

whitespace = [ \t]*
