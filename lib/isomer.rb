require_relative 'isomer/version'
require_relative 'isomer/errors'
require_relative 'isomer/base'
require_relative 'isomer/sources'

module Isomer
  def self.configure(source_type, options)
    Class.new(Isomer::Base) do
      yield(self)
    end.from(source_type, options)
  end
end
