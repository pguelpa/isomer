class Isomer::Base
  attr_reader :source, :base

  # Deprecated, use `Isomer::Configuration.hydrate` instead
  def self.from(source_type, options = {})
    source = Isomer::Sources.factory(source_type, [], options)
    nucleus = Isomer::Nucleus.new

    @parameters ||= []
    @parameters.each do |p|
      options = {
        name: p.name,
        required: p.required?
      }
      options[:default] = p.default if p.default

      nucleus.parameter(p.id, options)
    end

    config = Isomer::Configuration.hydrate(nucleus, source)
    if !config.valid?
      raise Isomer::RequiredParameterError, config.errors.join(', ')
    end
    config
  end

  def self.parameter(id, options = {})
    parameter = Isomer::Parameter.new(id, options)
    (@parameters ||= []) << parameter

    define_method(id) do
      source.for(parameter)
    end
  end

  def initialize(source)
    @source = source
  end
end
