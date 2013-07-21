require 'spec_helper'

describe Isomer::Base do
  describe '.from' do
    let(:klass) { Class.new(Isomer::Base) }
    let(:source) { double('Source', load: anything)}

    it 'passes along the type and options to the factory' do
      Isomer::Sources.
        should_receive(:factory).
        with(:foo, {bar: 'bar-option'}).
        and_return(source)

      klass.from(:foo, {bar: 'bar-option'})
    end
  end

  describe '.parameter' do
    let(:klass) do
      Class.new(Isomer::Base) do
        parameter :the_value, default: 'foo', required: true, from: 'bar'
      end
    end

    let(:instance) do
      klass.from(:test, payload: {})
    end

    it 'creates a method for the parameter' do
      instance.respond_to?(:the_value).should == true
    end

    it 'creates a new Parameter' do
      Isomer::Parameter.should_receive(:new).with(:the_value, {default: 'foo', required: true, from: 'bar'})
      instance
    end
  end
end
