class Isomer::Base
  attr_reader :source, :base

  def self.from(source_type, options = {})
    base = options.delete(:base)

    case source_type
    when :file
      path = options.delete(:path)
      source = Isomer::Sources::Yaml.new(path, base)
      source.load
    when :environment
      raise "Environment type not implemented yet"
    else
      raise "Unknown source type #{source_type}"
    end

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
