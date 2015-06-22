require 'spec_helper'

describe 'defining a configuration' do
  context 'with a single source' do
    it 'populates the configuration value with the source value' do
      nucleus = Isomer::Nucleus.new { |n| n.parameter :host }
      source = Isomer::Sources::Dictionary.new('host' => 'example.com')
      config = Isomer::Configuration.hydrate(nucleus, source)

      expect(config.host).to eq('example.com')
    end

    context 'with a parameter name alias' do
      it 'populates the configuration value using the override name parameter' do
        nucleus = Isomer::Nucleus.new { |n| n.parameter :host, name: 'hostname' }
        source = Isomer::Sources::Dictionary.new('hostname' => 'example.com')
        config = Isomer::Configuration.hydrate(nucleus, source)

        expect(config.host).to eq('example.com')
      end
    end

    context 'with a required parameter' do
      context 'with valid values for all required fields' do
        it 'is valid' do
          nucleus = Isomer::Nucleus.new do |n|
            n.parameter :host, required: true
            n.parameter :timeout, required: true
          end
          source = Isomer::Sources::Dictionary.new({'host' => anything, 'timeout' => anything})
          config = Isomer::Configuration.hydrate(nucleus, source)

          expect(config.valid?).to be(true)
        end

        it 'returns an empty array for errors' do
          nucleus = Isomer::Nucleus.new do |n|
            n.parameter :host, required: true
            n.parameter :timeout, required: true
          end
          source = Isomer::Sources::Dictionary.new({'host' => anything, 'timeout' => anything})
          config = Isomer::Configuration.hydrate(nucleus, source)

          expect(config.errors).to be_empty
        end
      end

      context 'with invalid values for any required fields' do
        it 'is invalid' do
          nucleus = Isomer::Nucleus.new do |n|
            n.parameter :host, required: true
            n.parameter :timeout, required: true
          end
          source = Isomer::Sources::Dictionary.new({'host' => anything})
          config = Isomer::Configuration.hydrate(nucleus, source)

          expect(config.valid?).to be(false)
        end

        it 'returns an array of errors' do
          nucleus = Isomer::Nucleus.new do |n|
            n.parameter :host, required: true
            n.parameter :timeout, required: true
            n.parameter :key, required: true
          end
          source = Isomer::Sources::Dictionary.new({'host' => '', 'key' => anything})
          config = Isomer::Configuration.hydrate(nucleus, source)

          expect(config.errors).to contain_exactly('timeout is required', 'host must not be empty')
        end
      end
    end

    context 'with a default parameter' do
      it 'populates the configuration value with the default when no source value is present' do
        nucleus = Isomer::Nucleus.new do |n|
          n.parameter :timeout, default: 300
        end
        source = Isomer::Sources::Dictionary.new({})
        config = Isomer::Configuration.hydrate(nucleus, source)

        expect(config.timeout).to eq(300)
      end

      it 'populates the configuration value with source value when it is present' do
        nucleus = Isomer::Nucleus.new do |n|
          n.parameter :timeout, default: 300
        end
        source = Isomer::Sources::Dictionary.new({'timeout' => 100})
        config = Isomer::Configuration.hydrate(nucleus, source)

        expect(config.timeout).to eq(100)
      end
    end
  end

  context 'with multiple sources' do
    it 'populates the configuration value with the source value' do
      nucleus = Isomer::Nucleus.new { |n| n.parameter :host }
      source_a = Isomer::Sources::Dictionary.new('host' => 'example.com')
      source_b = Isomer::Sources::Dictionary.new('host' => 'my-example.com')
      config = Isomer::Configuration.hydrate(nucleus, source_a, source_b)

      expect(config.host).to eq('my-example.com')
    end
  end
end
