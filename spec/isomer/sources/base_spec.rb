require 'spec_helper'

describe Isomer::Sources::Base do
  describe '.new' do
    it 'initalizes errors to an empty array' do
      source = Isomer::Sources::Base.new(anything)
      source.errors.should == []
    end
  end

  describe '#load' do
    it 'raises a NotImplementedError' do
      source = Isomer::Sources::Base.new(anything)
      expect {
        source.load
      }.to raise_error(NotImplementedError, "You must implement 'load' in Isomer::Sources::Base")
    end
  end

  describe '#validate' do
    it 'raises an error for any required parameters not specified' do
      parameter = Isomer::Parameter.new(:the_value, required: true)
      source = Isomer::Sources::Test.new([parameter], payload: {})
      source.load

      expect { source.validate }.to raise_error Isomer::RequiredParameterError
    end
  end

  describe '#for' do
    it 'returns the value for the parameter' do
      parameter = double('Parameter', name: 'name')
      source = Isomer::Sources::Test.new([parameter], payload: {'name' => 'value'})
      source.load

      source.for(parameter).should == 'value'
    end

    it 'handles setting a parameter to a boolean false correctly' do
      parameter = double('Parameter', name: 'my-boolean', default: true)
      source = Isomer::Sources::Test.new([parameter], payload: {'my-boolean' => false})
      source.load

      source.for(parameter).should == false
    end

    it 'returns the default if there is no configuration value' do
      parameter = double('Parameter', name: 'name', default: 'bar')
      source = Isomer::Sources::Test.new([parameter], payload: {})
      source.load

      source.for(parameter).should == 'bar'
    end
  end
end
