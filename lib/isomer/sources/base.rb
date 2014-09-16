class Isomer::Sources::Base
  attr_reader :parameters, :configuration, :errors

  def initialize(parameters)
    @parameters = parameters
    @errors = []
  end

  def load_and_validate
    load
    validate
  end

  def load
    raise NotImplementedError, "You must implement 'load' in #{self.class.name}"
  end

  def validate
    parameters.each do |parameter|
      if parameter.required?
        value = configuration[parameter.name]
        @errors << "#{parameter.name} is required" if valid(value)
      end
    end

    raise Isomer::RequiredParameterError, errors.join(', ') if !errors.empty?
  end

  def for(parameter)
    configuration.has_key?(parameter.name) ? configuration[parameter.name] : parameter.default
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