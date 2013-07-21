require 'spec_helper'

describe Isomer::Base do
  describe '.from' do
    let(:klass) { Class.new(Isomer::Base) { |c| c.parameter :something } }
    let(:source) { double('Source', load_and_validate: anything)}

    it 'passes along the type, parameters, and options to the factory' do
      parameter = double('Parameter', required?: false)
      Isomer::Parameter.stub(:new).and_return(parameter)

      Isomer::Sources.
        should_receive(:factory).
        with(:foo, [parameter], {bar: 'bar-option'}).
        and_return(source)

      klass.from(:foo, {bar: 'bar-option'})
    end
  end

  describe '.parameter' do
    let(:klass) do
      Class.new(Isomer::Base) do
        parameter :the_value, default: 'foo', from: 'bar'
      end
    end

    let(:instance) do
      klass.from(:test, payload: {'the_value' => 'my-value'})
    end

    it 'creates a method for the parameter' do
      instance.respond_to?(:the_value).should == true
    end

    it 'creates a new Parameter' do
      parameter = Isomer::Parameter.new(:double, {})
      Isomer::Parameter.should_receive(:new).
        with(:the_value, {default: 'foo', from: 'bar'}).
        and_return(parameter)

      instance
    end
  end
end
