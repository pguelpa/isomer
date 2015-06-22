module Isomer
  module Sources
    class Base
      def get(parameter)
        raise NotImplementedError, "You must implement 'get' in #{self.class.name}"
      end
    end
  end
end
