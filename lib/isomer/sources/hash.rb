class Isomer::Sources::Hash < Isomer::Sources::Base
  def initialize(configuration)
    @configuration = configuration
  end

  def get(name)
    @configuration[name]
  end
end
