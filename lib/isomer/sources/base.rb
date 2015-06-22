class Isomer::Sources::Base
  def get(parameter)
    raise NotImplementedError, "You must implement 'get' in #{self.class.name}"
  end
end
