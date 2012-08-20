// If we're in Node, require the AST module. Otherwise, assume it's been include in the page
{
  if (require) AST = require('./ast');

  input = AST.cleanInput(input);
}
template
  = root:rootNode subNodes:subNode*
  { return AST.treeifyNodes(root, subNodes); }

rootNode
  = node

subNode
  = indentation:whitespace node:node

node
  = tag:tag whitespace contentNode:contentNode? whitespace [\n]?
  {
    tag.setContent(contentNode);
    return tag;
  }

tag
  = tagName:tagName classesAndId:classOrId* { return AST.Node(tagName, classesAndId) }
  / classesAndId:classOrId+                 { return AST.Node(null,    classesAndId) }

tagName
  = chars:[a-z0-9]+ { return chars.join('') }

classOrId
  = className
  / idName

className
  = '.' chars:[a-z0-9]+ { return AST.Class(chars.join('')) }

idName
  = '#' chars:[a-z0-9]+ { return AST.Id(chars.join('')) }

contentNode
  = text:[^\n]+ [\n]? { return text.join('') }

whitespace
  = [ \t]*
