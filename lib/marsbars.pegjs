// If we're in Element, require the AST module. Otherwise, assume it's been include in the page
{
  if (require) AST = require('./ast');

  input = AST.cleanInput(input);
}
template
  = root:rootElement subNodes:subNode*
  { return AST.treeifyElements(root, subNodes); }

rootElement = element

subNode
  = indentation:whitespace node:node
  { return node.setIndentation(indentation.join('')); }

node = element / outlineTextNode

element
  = tag:tag contentNode:inlineContentNode? whitespace [\n]?
  {
    if (contentNode) tag.addChild(contentNode);
    return tag;
  }

tag
  = tagName:tagName classesAndId:classOrId* { return AST.Element(tagName, classesAndId); }
  / classesAndId:classOrId+                 { return AST.Element(null,    classesAndId); }

tagName
  = chars:[a-z0-9]+ { return chars.join(''); }

classOrId = className / idName

className
  = '.' chars:[a-z0-9]+ { return AST.Class(chars.join('')); }

idName
  = '#' chars:[a-z0-9]+ { return AST.Id(chars.join('')); }

inlineContentNode
  = [ \s]+ textNode:inlineTextNode { return textNode }

inlineTextNode = textNode

outlineTextNode =
  "|" whitespace textNode:textNode { return textNode; }

textNode
  = text:[^\n]+ [\n]? { return AST.TextNode(text.join('')); }

whitespace = [ \t]*
