require 'yaml'

class Isomer::Sources::Yaml < Isomer::Sources::Base
  attr_reader :file, :base

  def initialize(parameters, options={})
    @file = options[:file]
    @base = options[:base]

    super(parameters)
  end

  def load
    if File.exists?(file)
      values = YAML.load_file(file)
      if base && values.has_key?(base)
        @configuration = values[base]
      else
        @configuration = values
      end
    end
  end
end
