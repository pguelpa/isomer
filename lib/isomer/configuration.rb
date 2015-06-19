class Isomer::Configuration
  attr_reader :nucleus, :sources

  def self.hydrate(nucleus, *sources)
    klass = Class.new(self) do
      nucleus.parameters.each do |id, parameter|
        define_method(id) { get(parameter) }
      end
    end
    config = klass.new(nucleus, *sources)
    config.validate!
    config
  end

  def initialize(nucleus, *sources)
    @nucleus = nucleus
    @sources = sources
  end

  def validate!
    errors = @nucleus.parameters.map do |_, p|
      p.validate(get(p)) if p.required?
    end.compact

    raise Isomer::RequiredParameterError, errors.join(', ') if !errors.empty?
  end

  def get(parameter)
    sources.map { |s| s.get(parameter.name) }.last || parameter.default
  end
end
