class Isomer::Base
  attr_reader :source, :base

  def self.from(source_type, options = {})
    source = Isomer::Sources.factory(source_type, @parameters, options)
    source.load_and_validate

    new(source)
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
