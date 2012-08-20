# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch 'Gemfile'
end

guard 'coffeescript', input: 'lib'
guard 'coffeescript', input: 'spec'

guard "jasmine-node", jasmine_node_bin: 'jasmine-node' do
  watch %r{^spec/.+.spec\.js$}
  watch(%r{^lib/(.+)\.js$}) { |m| "spec/lib/#{m[1]}.spec.js" }
  watch 'spec/spec_helper.js'
end

# Compile our PEGJS
guard :shell do
  watch %r{^lib/(.+)\.pegjs$} do |m|
    pegjs = m[0]
    puts "Compiling #{pegjs}"
    parserjs = pegjs.sub(/\.pegjs/, '.parser.js')
    `pegjs '#{pegjs}' '#{parserjs}'`
    p $?
  end
end

