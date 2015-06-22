require 'yaml'

module Isomer
  module Sources
    class Yaml < Isomer::Sources::Base
      attr_reader :file, :base, :required

      def initialize(file, options={})
        @file = file
        @required = !!options[:required]

        @base = options[:base]
      end

      def get(name)
        configuration[name]
      end

      private

      def configuration
        @configuration ||= load
      end

      def load
        if File.exists?(file)
          values = YAML.load_file(file)
          if !values.instance_of?(::Hash)
            {}
          elsif base && values.has_key?(base)
            values[base] || {}
          else
            values
          end
        else
          raise Isomer::Error, "Missing required configuration file '#{file}'" if required
          {}
        end
      end
    end
  end
end
