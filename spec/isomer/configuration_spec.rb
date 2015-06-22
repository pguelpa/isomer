require 'spec_helper'

describe Isomer::Configuration do
  describe '.hydrate' do
    it 'returns an instance of a subclass of itself' do
      nucleus = Isomer::Nucleus.new
      expect(described_class.hydrate(nucleus)).to be_a_kind_of(Isomer::Configuration)
    end

    it 'returns an object that responds to the parameters defined in the nucleus' do
      nucleus = Isomer::Nucleus.new { |n| n.parameter :foo }

      config = described_class.hydrate(nucleus)
      expect(config).to respond_to(:foo)
    end

    it 'defines a method for each parameter that returns the appropriate parameter' do
      source = Isomer::Sources::Dictionary.new('foo' => 'bar')
      nucleus = Isomer::Nucleus.new { |n| n.parameter :foo }

      config = described_class.hydrate(nucleus, source)
      expect(config.foo).to eq('bar')
    end
  end

  describe '#errors' do
    context 'with no validations' do
      it 'does not return any errors' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter :foo }
        config = described_class.new(nucleus)

        expect(config.errors).to be_empty
      end
    end

    context 'with validations' do
      it 'returns an error for any required parameters not set in any source' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter(:name, required: true) }
        config = described_class.new(nucleus)

        expect(config.errors).to eq(['name is required'])
      end

      it 'returns an error for any required parameters that are blank' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter(:name, required: true) }
        source = Isomer::Sources::Dictionary.new('name' => '')
        config = described_class.new(nucleus, source)

        expect(config.errors).to eq(['name must not be empty'])
      end

      it 'returns an empty array when there are no errors' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter(:name, required: true) }
        source = Isomer::Sources::Dictionary.new('name' => 'Shaggy')
        config = described_class.new(nucleus, source)

        expect(config.errors).to eq([])
      end
    end
  end

  describe '#valid?' do
    context 'with no validations' do
      it 'returns true' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter :foo }
        config = described_class.new(nucleus)

        expect(config.valid?).to be(true)
      end
    end

    context 'with validations' do
      it 'returns true when there are no validation errors' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter(:name, required: true) }
        source = Isomer::Sources::Dictionary.new('name' => 'Scooby')
        config = described_class.new(nucleus, source)

        expect(config.valid?).to be(true)
      end

      it 'returns false when there are validation errors' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter(:name, required: true) }
        config = described_class.new(nucleus)

        expect(config.valid?).to be(false)
      end
    end
  end

  describe '#get' do
    context 'when no source defines a value' do
      it 'returns the default value if defined' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter :bar, default: 'baz' }
        config = described_class.new(nucleus)

        expect(config.get(nucleus.parameters[:bar])).to eq('baz')
      end

      it 'returns nil if no default value is defined' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter :bar }
        config = described_class.new(nucleus)

        expect(config.get(nucleus.parameters[:bar])).to be_nil
      end
    end

    context 'when one or more sources define a value' do
      it 'returns the last non-nil value defined by any source' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter :bar, default: 'baz' }
        source_1 = Isomer::Sources::Dictionary.new('bar' => 'boop')
        source_2 = Isomer::Sources::Dictionary.new('bar' => 'blop')
        source_3 = Isomer::Sources::Dictionary.new({})
        config = described_class.new(nucleus, source_1, source_2, source_3)

        expect(config.get(nucleus.parameters[:bar])).to eq('blop')
      end
    end
  end
end
