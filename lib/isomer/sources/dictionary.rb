module Isomer
  module Sources
    class Dictionary < Isomer::Sources::Base
      def initialize(configuration)
        @configuration = configuration
      end

      def get(name)
        @configuration[name]
      end
    end
  end
end
