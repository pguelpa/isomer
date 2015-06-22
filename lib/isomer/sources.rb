require_relative 'sources/base'
require_relative 'sources/environment'
require_relative 'sources/hash'
require_relative 'sources/yaml'

module Isomer
  module Sources
    # Deprecated, initialize a source directly now
    def self.factory(type, parameters=[], options={})
      case type
      when :test
        Isomer::Sources::Hash.new(options[:payload])
      when :yaml
        Isomer::Sources::Yaml.new(options)
      when :environment
        Isomer::Sources::Environment.new(options)
      else
        raise "Unknown source type #{source_type}"
      end
    end
  end
end
