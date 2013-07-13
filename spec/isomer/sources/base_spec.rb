require 'spec_helper'

describe Isomer::Sources::Base do
  describe '#load' do
    it 'raises a NotImplementedError' do
      source = Isomer::Sources::Base.new(anything)
      expect {
        source.load
      }.to raise_error(NotImplementedError, "You must implement 'load' in Isomer::Sources::Base")
    end
  end

  describe '#for' do
    let(:source) { Isomer::Sources::Base.new }

    it 'returns the value for the parameter' do
      source.stub(:configuration).and_return( {'name' => 'value'} )
      source.for('name').should == 'value'
    end

    it 'converts the parameter to a string' do
      source.stub(:configuration).and_return( {'name' => 'value'} )
      source.for(:name).should == 'value'
    end
  end
end
