require 'spec_helper'

describe Isomer::Configuration do
  describe '.hydrate' do
    it 'returns an instance of a subclass of itself' do
      nucleus = Isomer::Nucleus.build
      expect(described_class.hydrate(nucleus)).to be_a_kind_of(Isomer::Configuration)
    end

    it 'returns an object that responds to the parameters defined in the nucleus' do
      nucleus = Isomer::Nucleus.build { |n| n.parameter :foo }

      config = described_class.hydrate(nucleus)
      expect(config).to respond_to(:foo)
    end

    it 'defines a method for each parameter that returns the appropriate parameter' do
      source = Isomer::Sources::Hash.new('foo' => 'bar')
      nucleus = Isomer::Nucleus.build { |n| n.parameter :foo }

      config = described_class.hydrate(nucleus, source)
      expect(config.foo).to eq('bar')
    end

    it 'runs validations' do
      nucleus = Isomer::Nucleus.build { |n| n.parameter :foo, required: true }

      expect {
        described_class.hydrate(nucleus)
      }.to raise_error(Isomer::RequiredParameterError)
    end
  end

  describe '#validate!' do
    context 'with no validations' do
      it 'should not raise any errors' do
        nucleus = Isomer::Nucleus.build { |n| n.parameter :foo }
        config = described_class.new(nucleus)

        expect { config.validate! }.to_not raise_error
      end
    end

    context 'with validations' do
      it 'raises an error for any required parameters not set in any source' do
        nucleus = Isomer::Nucleus.build do |n|
          n.parameter(:name, required: true)
          n.parameter(:phone)
          n.parameter(:email, required: true)
        end
        config = described_class.new(nucleus)

        expect { config.validate! }.to raise_error(Isomer::RequiredParameterError, "name is required, email is required")
      end
    end
  end

  describe '#get' do
    context 'when no source defines a value' do
      it 'returns the default value if defined' do
        nucleus = Isomer::Nucleus.build { |n| n.parameter :bar, default: 'baz' }
        config = described_class.new(nucleus)

        expect(config.get(nucleus.parameters[:bar])).to eq('baz')
      end

      it 'returns nil if no default value is defined' do
        nucleus = Isomer::Nucleus.build { |n| n.parameter :bar }
        config = described_class.new(nucleus)

        expect(config.get(nucleus.parameters[:bar])).to be_nil
      end
    end

    context 'when one or more sources define a value' do
      it 'returns the last value defined by any source' do
        nucleus = Isomer::Nucleus.build { |n| n.parameter :bar, default: 'baz' }
        source_1 = Isomer::Sources::Hash.new('bar' => 'boop')
        source_2 = Isomer::Sources::Hash.new('bar' => 'blop')
        source_3 = Isomer::Sources::Hash.new('bar' => 'pop')
        config = described_class.new(nucleus, source_1, source_2, source_3)

        expect(config.get(nucleus.parameters[:bar])).to eq('pop')
      end
    end
  end
end
