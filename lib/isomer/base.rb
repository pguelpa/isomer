class Isomer::Base
  attr_reader :source, :base

  def self.from(source_type, options = {})
    base = options.delete(:base)

    case source_type
    when :test
      payload = options.delete(:payload)
      source = Isomer::Sources::Test.new(payload, base)
    when :yaml
      path = options.delete(:path)
      source = Isomer::Sources::Yaml.new(path, base)
    when :environment
      raise "Environment type not implemented yet"
    else
      raise "Unknown source type #{source_type}"
    end

    source.load
    new(source)
  end

  def self.parameter(name, options = {})
    define_method(name) do
      value = source.for(options[:name] || name)

      if value.nil? && options[:required]
        raise Isomer::RequiredParameterError, "'#{name}' is a required parameter"
      end

      value || options[:default]
    end
  end

  def initialize(source)
    @source = source
  end
end
