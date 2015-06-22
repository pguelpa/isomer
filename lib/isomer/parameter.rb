class Isomer::Parameter
  attr_reader :id, :default

  def initialize(id, options={})
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

  def validate(value)
    if value.respond_to?(:empty?) && value.empty?
      "#{name} must not be empty"
    elsif value.nil?
      "#{name} is required"
    end
  end
end
