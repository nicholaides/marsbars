# MarsBars

Marsbars is a templating language for Handlebars/Ember.js in the spirit of Haml and Jade. It has 2 important benefits:

1) Less extraneous markup.
2) HTML tag names, classes, and id's of the Em.View class definitions go in the template, where they belong.

## Syntax

### Root Element

Every Marsbars template must have exactly 1 root element. This element is special in that its tag name, classes and id are assigned to the view that uses the template. Root elements cannot have Handlebars helpers, like `bindAttr` and `action` (yet).

Take this template as an example (`user_view.marsbars`):

```
section.user#current-user
  .name John
  .twitter @johnstamos
```

and this view that uses the template:

```javascript
App.UserView = MarsbarsEmber.View('user_view').extend({
  // ... normal view stuff
})
```

The `App.UserView` gets from the Marsbars template a `tagName` of `section`, `classNames` of `['user']` and `elementId` of `current-user`.

### Tag names, classes and ids and attributes

`img.logo#main-logo(src="company.png" height="100")` => `<img class="logo" id="main-logo" src="company.png" height="100">`

`.bookmark` => `<div class="bookmark"></div>`

### Text

`h1 About Us` => `<h1>About Us</h1>`

```html
p
  | We are
  | really nice
  img(src="smiley.png")
```

becomes

`<p>We are really nice <img src="smiley.png"></p>`

### Indentation

Marsbars uses significant whitespace (GASP!!) for nesting elements. It is spaces/tabs agnostic. Whichever style you use for your first indented line is what is used for the rest of the template. Example:

```
ul
  li Home
  li About Us
    ul
      li Our Vision
  li Disclaimer
```

becomes

```html
<ul>
  <li>Home</li>
  <li>
    <ul>
      <li>Our Vision</li>
    </ul>
  </li>
  <li>Disclaimer</li>
</ul>
```

### Dynamic Content

`= name` => `{{name}}`

`== name` => `{{{name}}}`

`.user= name` => `<div class="user">{{name}}</div>`

`= view App.UserView contentBinding="user"` => `{{view App.UserView contentBinding="user"}}`

```
- if view.isActive
  .active
- else
  .inactive
```
becomes
```handlebars
{{#if view.isActive}}
  <div class="active"></div>
{{else}}
  <div class="inactive"></div>
{{/if}}
```

```
- each item in list
  = item
```
becomes
```handlebars
{{#each item in list}}
  {{item}}
{{/each}}
```

```
- view App.UserView contentBinding="user"
  = name
```
becomes
```Handlebars
{{#view App.UserView contentBinding="user"}}
  {{name}}
{{/view}}
```

`button{bindAttr disabled="cantPost"} Post` => `<button {{bindAttr disabled="cantPost"}}>Post</button>`

`a(rel="next"){action showNext} next` => `<a rel="next" {{action showNext}}>next</a>`

coming soon: `img( src={user.imageUrl} height="100" )` => `<img height="100" {{bindAttr src="user.imageUrl"}}>



## Installation

### Getting the files
To get the latest version of Marsbars, clone this repo, do `npm install` (requires Node.js and NPM) and then `grunt`. The `build/dist` directory will contain files ready for use.

#### Installation w Ember.js
To use marsbars with Ember.js include `build/dist/ember.js` via a `<script>` tag.

#### Standalone Parser
If you want to use the parser on its own use `build/dist/marsbars.js`

### Rails/Sprockets

You can serve `.marsbars` files from your javascripts directory. The following setup assumes you'll have your templates in the `templates` directory (e.g. if you're using Rails, that's `app/assets/javascripts/templates`).

For Rails/Rack apps, you'll need this class:

```ruby
class MarsbarsTemplate < Tilt::Template
  def self.default_mime_type
    "application/javascript"
  end

  def prepare; end

  def evaluate(scope, locals, &block)
    # if you want your template/view names to begin w/ 'template/', remove the call to gsub
    path = scope.logical_path.gsub(/^templates\//, '')
    "MarsbarsEmber.TEMPLATES_MARKUP[#{path.to_json}] = #{data.to_json};"
  end
end
```

#### Rails

Use the above `MarsbarsTemplate` class with this in your enviroment file:

```ruby
app.assets.register_engine '.marsbars', MarsbarsTemplate
```

#### Sprockets (Sinatra, Rack, etc)

Use the above `MarsbarsTemplate` class with Sprockets:

```ruby
sprockets_rack_app.register_engine '.marsbars', MarsbarsTemplate
```
