# MarsBars

## Using with Ember.js

Marsbars creates Em.View classes that automatically set up their `tagName`, `classNames`, and `elementId` properties based on the root element of your template.

`user_view.marsbars`:
```
section.user

  .name= name
  .twitter= view.twitter_handle
```

```coffee
App.UserView = MarsbarsEmber.View('user_view').extend({ // assumes a template named 'test-view'
  // ... normal view stuff
  // tagName already set to "section"
  // classNames already set to ['user']
})
```

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
