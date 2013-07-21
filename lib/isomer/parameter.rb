class Isomer::Parameter
  attr_reader :default

  def initialize(id, options)
    @id = id
    @required = options[:required] || false
    @alias = options[:alias]
    @default = options[:default]
  end

  def name
    (@alias|| @id).to_s
  end

  def required?
    @required === true
  end
end