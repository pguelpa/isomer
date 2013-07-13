require 'yaml'

class Isomer::Sources::Yaml < Isomer::Sources::Base
  attr_reader :path

  def initialize(path, base = nil)
    @path = path
    super(base)
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
end
