require 'yaml'

class Isomer::Sources::Yaml < Isomer::Sources::Base
  attr_reader :file, :base, :required

  def initialize(parameters, options={})
    @file = options[:file]
    raise Isomer::Error, "YAML source requires the 'file' parameter" if file.nil? || file.empty?

    @base = options[:base]
    @required = !!options[:required]

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
    else
      raise Isomer::Error, "Missing required configuration file '#{file}'" if required
      @configuration = {}
    end
  end
end
