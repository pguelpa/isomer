module Isomer::Sources
  def self.factory(type, parameters=[], options={})
    case type
    when :test
      Isomer::Sources::Test.new(parameters, options)
    when :yaml
      Isomer::Sources::Yaml.new(parameters, options)
    when :environment
      Isomer::Sources::Environment.new(parameters, options)
    else
      raise "Unknown source type #{source_type}"
    end
  end
end

require_relative 'sources/base'
require_relative 'sources/test'
require_relative 'sources/yaml'
require_relative 'sources/environment'
