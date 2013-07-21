class Isomer::Parameter
  attr_reader :default

  def initialize(id, options)
    @id = id
    @required = options[:required] || false
    @from = options[:from]
    @default = options[:default]
  end

  def name
    (@from || @id).to_s
  end

  def required?
    @required === true
  end
end