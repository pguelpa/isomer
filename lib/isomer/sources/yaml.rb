require 'yaml'

class Isomer::Sources::Yaml
  attr_reader :path, :base, :configuration

  def initialize(path, base = nil)
    @path = path
    @base = base
  end

  def load
    if File.exists?(path)
      values = YAML.load_file(path)
      if base && values.has_key?(base)
        @configuration = values[base]
      else
        @configuration = values
      end
    end
  end

  def for(parameter)
    configuration[parameter]
  end
end
