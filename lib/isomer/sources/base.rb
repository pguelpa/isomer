class Isomer::Sources::Base
  attr_reader :base, :configuration

  def initialize(base = nil)
    @base = base
  end

  def load
    raise NotImplementedError, "You must implement 'load' in #{self.class.name}"
  end

  def for(parameter)
    configuration[parameter.to_s]
  end
end