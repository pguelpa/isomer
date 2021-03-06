require_relative 'isomer/base'
require_relative 'isomer/configuration'
require_relative 'isomer/errors'
require_relative 'isomer/nucleus'
require_relative 'isomer/parameter'
require_relative 'isomer/sources'
require_relative 'isomer/version'

module Isomer
  # Deprecated, use `Isomer::Configuration` instead
  def self.configure(source_type, options)
    Class.new(Isomer::Base) do
      yield(self)
    end.from(source_type, options)
  end

  class << self
    extend Gem::Deprecate
    deprecate :configure, 'Isomer::Configuration', 2016, 1
  end
end
