module Isomer
  module Sources
    class Test < Isomer::Sources::Base
      attr_accessor :payload

      def initialize(parameters, options={})
        @payload = options[:payload]
        super(parameters)
      end

      def load
        @configuration = payload
      end
    end
  end
end
