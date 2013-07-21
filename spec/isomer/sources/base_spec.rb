require 'spec_helper'

describe Isomer::Sources::Base do
  describe '.new' do
    it 'initalizes errors to an empty array' do
      source = Isomer::Sources::Base.new
      source.errors.should == []
    end
  end

  describe '#load' do
    it 'raises a NotImplementedError' do
      source = Isomer::Sources::Base.new(anything)
      expect {
        source.load(anything)
      }.to raise_error(NotImplementedError, "You must implement 'load' in Isomer::Sources::Base")
    end
  end

  describe '#validate' do
    it 'raises an error for any required parameters not specified' do
      parameter = Isomer::Parameter.new(:the_value, required: true)
      source = Isomer::Sources::Test.new({})
      source.load([parameter])
      expect { source.validate( [parameter] ) }.to raise_error Isomer::RequiredParameterError
    end
  end

  describe '#for' do
    let(:source) { Isomer::Sources::Base.new }

    it 'returns the value for the parameter' do
      parameter = double('Parameter', name: 'name')
      source.stub(:configuration).and_return( {'name' => 'value'} )
      source.for(parameter).should == 'value'
    end

    it 'returns the default if there is no configuration value' do
      parameter = double('Parameter', name: 'name', default: 'bar')
      source.stub(:configuration).and_return({})
      source.for(parameter).should == 'bar'
    end
  end
end
