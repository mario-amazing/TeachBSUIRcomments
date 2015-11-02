require 'yaml'
require 'pry'
thing = YAML.load_file('some.yml')
binding.pry
puts thing.inspect
