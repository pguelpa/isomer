class Isomer::Parameter
  attr_reader :default

  def initialize(id, options)
    @id = id
    @required = options[:required] || false
    @name = options[:name]
    @default = options[:default]
  end

  def name
    (@name || @id).to_s
  end

  def required?
    @required === true
  end
end