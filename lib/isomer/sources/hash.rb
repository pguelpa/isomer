module Isomer
  module Sources
    class Hash < Isomer::Sources::Base
      def initialize(configuration)
        @configuration = configuration
      end

      def get(name)
        @configuration[name]
      end
    end
  end
end
