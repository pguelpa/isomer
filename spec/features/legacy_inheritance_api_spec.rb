require 'spec_helper'

describe 'defining a legacy inline configuration' do
  it 'populates the configuration value with the source value' do
    klass = Class.new(Isomer::Base) do
      parameter :host
    end

    config = klass.from(:test, payload: {'host' => 'example.com'})
    expect(config.host).to eq('example.com')
  end

  context 'with a parameter name alias' do
    it 'populates the configuration value using the override name parameter' do
      klass = Class.new(Isomer::Base) do
        parameter :host, name: 'hostname'
      end

      config = klass.from(:test, payload: {'hostname' => 'example.com'})
      expect(config.host).to eq('example.com')
    end
  end

  context 'with a required parameter' do
    it 'does not raise errors when all required fields are present' do
      klass = Class.new(Isomer::Base) do
        parameter :host, required: true
        parameter :timeout, required: true
      end

      expect {
        klass.from(:test, payload: {'host' => 'example.com', 'timeout' => 100})
      }.to_not raise_error
    end

    it 'raises an error when any required field is not present' do
      klass = Class.new(Isomer::Base) do
        parameter :host, required: true
        parameter :timeout, required: true
      end

      expect {
        klass.from(:test, payload: {'host' => 'example.com'})
      }.to raise_error(Isomer::RequiredParameterError, 'timeout is required')
    end
  end

  context 'with a default parameter' do
    it 'populates the configuration value with the default when no source value is present' do
      klass = Class.new(Isomer::Base) do
        parameter :timeout, default: 300
      end

      config = klass.from(:test, payload: {})
      expect(config.timeout).to eq(300)
    end

    it 'populates the configuration value with source value when it is present' do
      klass = Class.new(Isomer::Base) do
        parameter :timeout, default: 300
      end

      config = klass.from(:test, payload: {'timeout' => 100})
      expect(config.timeout).to eq(100)
    end
  end
end
