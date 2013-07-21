class Isomer::Sources::Base
  attr_reader :base, :configuration, :errors

  def initialize(base = nil)
    @base = base
    @errors = []
  end

  def load(parameters)
    raise NotImplementedError, "You must implement 'load' in #{self.class.name}"
  end

  def load_and_validate(parameters)
    load(parameters)
    validate(parameters)
  end

  def validate(parameters)
    parameters.each do |parameter|
      if parameter.required?
        value = configuration[parameter.name]
        @errors << "#{parameter.name} is required" if valid(value)
      end
    end

    raise Isomer::RequiredParameterError, errors.join(', ') if !errors.empty?
  end

  def for(parameter)
    configuration[parameter.name] || parameter.default
  end

  private

  def valid(value)
    if value.respond_to?(:empty)
      value.empty?
    else
      value.nil?
    end
  end
end