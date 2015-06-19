class Isomer::Sources::Environment < Isomer::Sources::Base
  attr_reader :prefix

  def initialize(options={})
    @convert_case = options.has_key?(:convert_case) ? options[:convert_case] : true
    @prefix = options[:prefix]
  end

  def convert_case?
    @convert_case
  end

  def get(name)
    ENV[ convert_name(name) ]
  end

  private

  def convert_name(name)
    converted = "#{prefix}#{name}"
    convert_case? ? converted.upcase : converted
  end
end
