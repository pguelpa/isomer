module Isomer
  class Configuration
    attr_reader :nucleus, :sources

    def self.hydrate(nucleus, *sources)
      klass = Class.new(self) do
        nucleus.parameters.each do |id, parameter|
          define_method(id) { get(parameter) }
        end
      end
      klass.new(nucleus, *sources)
    end

    def initialize(nucleus, *sources)
      @nucleus = nucleus
      @sources = sources
    end

    def valid?
      errors.empty?
    end

    def errors
      @nucleus.parameters.map do |_, p|
        p.validate(get(p)) if p.required?
      end.compact
    end

    def get(parameter)
      sources.map { |s| s.get(parameter.name) }.compact.last || parameter.default
    end
  end
end
