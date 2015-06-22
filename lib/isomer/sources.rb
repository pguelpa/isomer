require_relative 'sources/base'
require_relative 'sources/dictionary'
require_relative 'sources/environment'
require_relative 'sources/yaml'

module Isomer
  module Sources
    # Deprecated, initialize a source directly now
    def self.factory(type, parameters=[], options={})
      case type
      when :test
        Isomer::Sources::Dictionary.new(options[:payload])
      when :yaml
        file = options.delete(:file)
        Isomer::Sources::Yaml.new(file, options)
      when :environment
        Isomer::Sources::Environment.new(options)
      else
        raise "Unknown source type #{source_type}"
      end
    end
  end
end
