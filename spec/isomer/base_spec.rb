require 'spec_helper'

describe Isomer::Base do
  describe '.from' do
    it 'creates a source using the old factory method' do
      klass = Class.new(Isomer::Base)

      parameter = Isomer::Parameter.new(anything)
      allow(Isomer::Parameter).to receive(:new).and_return(parameter)

      expect(Isomer::Sources).to receive(:factory).with(:foo, [], {bar: 'bar-option'})

      klass.from(:foo, {bar: 'bar-option'})
    end

    it 'defines each of the class "parameters" on the nucleous' do
      klass = Class.new(Isomer::Base) do |c|
        c.parameter :something, required: true
        c.parameter :another_thing, name: 'that_thing', default: 1
      end

      nucleous = Isomer::Nucleus.new
      allow(Isomer::Nucleus).to receive(:new).and_return(nucleous)

      expect(nucleous).to receive(:parameter).with(:something, name: 'something', required: true)
      expect(nucleous).to receive(:parameter).with(:another_thing, name: 'that_thing', required: false, default: 1)

      klass.from(:test, payload: {})
    end

    it 'hydrates and returns a configuration object' do
      klass = Class.new(Isomer::Base) { |c| c.parameter :something }

      config = klass.from(:test, payload: {'something' => 'value a'})
      expect(config.something).to eq('value a')
    end
  end

  describe '.parameter' do
    let(:klass) { Class.new(Isomer::Base) }

    it 'creates a method for the parameter' do
      klass.parameter(:the_value, default: 'foo', from: 'bar')
      instance = klass.new(anything)
      expect(instance).to respond_to(:the_value)
    end

    it 'creates a new Parameter' do
      parameter = Isomer::Parameter.new(:double, {})
      expect(Isomer::Parameter).to receive(:new).
        with(:the_value, {default: 'foo', from: 'bar'}).
        and_return(parameter)

      klass.parameter(:the_value, default: 'foo', from: 'bar')
    end
  end
end
