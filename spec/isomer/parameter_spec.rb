require 'spec_helper'

describe Isomer::Parameter do
  describe '#default' do
    it 'is set from the initializer' do
      parameter = Isomer::Parameter.new(:foo, default: 'my default')
      expect(parameter.default).to eq('my default')
    end
  end

  describe '#name' do
    context 'when there is no from option' do
      it 'returns the id as a string' do
        parameter = Isomer::Parameter.new(:foo)
        expect(parameter.name).to eq('foo')
      end
    end

    context 'when there is a from option' do
      it 'returns the from value as a string' do
        parameter = Isomer::Parameter.new(:bar, name: :baz)
        expect(parameter.name).to eq('baz')
      end
    end
  end

  describe '#required?' do
    it 'returns true when required is set to true' do
      parameter = Isomer::Parameter.new(anything, required: true)
      expect(parameter.required?).to be(true)
    end

    it 'returns false when required is set to anything other than true' do
      parameter = Isomer::Parameter.new(anything, required: 'blarg')
      expect(parameter.required?).to be(false)
    end
  end

  describe '#validate' do
    context 'when the value is invalid' do
      it 'returns an error if the value responds to `empty?` with true' do
        parameter = Isomer::Parameter.new('puppies', required: true)
        expect(parameter.validate([])).to eq('puppies must not be empty')
      end

      it 'returns an error if the value is nil' do
        parameter = Isomer::Parameter.new('name', required: true)
        expect(parameter.validate(nil)).to eq('name is required')
      end
    end

    it 'returns nil if the value is valid' do
      parameter = Isomer::Parameter.new(anything, required: true)
      expect(parameter.validate('my-value')).to be_nil
    end
  end
end
