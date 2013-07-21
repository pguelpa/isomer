module Isomer::Sources
  def self.factory(type, options={})
    base = options.delete(:base)

    case type
    when :test
      payload = options.delete(:payload)
      Isomer::Sources::Test.new(payload, base)
    when :yaml
      path = options.delete(:path)
      Isomer::Sources::Yaml.new(path, base)
    when :environment
      raise "Environment type not implemented yet"
    else
      raise "Unknown source type #{source_type}"
    end
  end
end

require_relative 'sources/base'
require_relative 'sources/test'
require_relative 'sources/yaml'
