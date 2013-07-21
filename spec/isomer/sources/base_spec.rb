require 'spec_helper'

describe Isomer::Sources::Base do
  describe '#load' do
    it 'raises a NotImplementedError' do
      source = Isomer::Sources::Base.new(anything)
      expect {
        source.load(anything)
      }.to raise_error(NotImplementedError, "You must implement 'load' in Isomer::Sources::Base")
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
