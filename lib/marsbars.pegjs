template
  = root:node nodes:indentedNode* {
                                    root.children = nodes;
                                    return root
                                  }

node
  = tag:tag tagContents:tagContents    { tag.contents = tagContents; return tag }
  / tag:tag whitespace:[\s]* eol:[\n]* { return tag }

indentedNode
  = indentation:[ ]+ node:node { node.indentation = indentation.join(''); return node }

tag
  = tagName:tagName classesAndId:classOrId* { return { tag: { name: tagName, classesAndId: classesAndId } } }
  / classesAndId:classOrId+                 { return { tag: {                classesAndId: classesAndId } } }

tagName
  = chars:[a-z0-9]+ { return chars.join('') }

classOrId
  = className:className
  / idName:idName

className
  = '.' chars:[a-z0-9]+ { return {className: chars.join('')} }

idName
  = '#' chars:[a-z0-9]+ { return {id: chars.join('')} }

tagContents
  = ( space:[\s]+ text:.* )+ eol:[\n]* { return text.join('') }
