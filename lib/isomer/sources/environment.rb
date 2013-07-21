class Isomer::Sources::Environment < Isomer::Sources::Base
  attr_reader :prefix

  def initialize(parameters, options={})
    @convert_case = options.has_key?(:convert_case) ? options[:convert_case] : true
    @prefix = options[:prefix]

    super(parameters)
  end

  def load
    @configuration = {}
    parameters.each do |parameter|
      @configuration[parameter.name] = ENV[ convert_name(parameter.name) ]
    end
  end

  def convert_case?
    @convert_case
  end

  private

  def convert_name(name)
    converted = [prefix, name].compact.join
    convert_case? ? converted.upcase : converted
  end
end