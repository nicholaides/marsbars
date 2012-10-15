# MarsBars

## Setup

In a script tag, include the `marsbars.js` that's in the `dist` directory. (TODO: make build system work so that these instructions work)

### Rails/Sprockets

You can serve `.marsbars` files from your javascripts directory. The following setup assumes you'll have your templates in the `templates` directory (i.e. if you're using Rails, that's `app/assets/javascripts/templates`).

For Rails/Rack apps, you'll need this class:

```ruby
class MarsbarsTemplate < Tilt::Template
  def self.default_mime_type
    "application/javascript"
  end

  def prepare; end

  def evaluate(scope, locals, &block)
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
