require 'spec_helper'

describe Isomer::Parameter do
  describe '#default' do
    it 'is set from the initializer' do
      parameter = Isomer::Parameter.new(:foo, {default: 'my default'})
      parameter.default.should == 'my default'
    end
  end

  describe '#name' do
    context 'when there is no alias' do
      it 'returns the id as a string' do
        parameter = Isomer::Parameter.new(:foo, {})
        parameter.name.should == 'foo'
      end
    end

    context 'when there is an alias' do
      it 'returns the alias as a string' do
        parameter = Isomer::Parameter.new(:bar, {alias: :baz})
        parameter.name.should == 'baz'
      end
    end
  end

  describe '#required?' do
    it 'returns true when required is set to true' do
      parameter = Isomer::Parameter.new(anything, {required: true})
      parameter.required?.should == true
    end

    it 'returns false when required is set to anything other than true' do
      parameter = Isomer::Parameter.new(anything, {required: 'blarg'})
      parameter.required?.should == false
    end
  end
end