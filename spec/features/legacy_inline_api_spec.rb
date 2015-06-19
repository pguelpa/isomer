require 'spec_helper'

describe 'defining a legacy inline configuration' do
  it 'populates the configuration value with the source value' do
    config = Isomer.configure(:test, payload: {'host' => 'example.com'}) do |config|
      config.parameter :host
    end

    expect(config.host).to eq('example.com')
  end

  context 'with a parameter name alias' do
    it 'populates the configuration value using the override name parameter' do
      config = Isomer.configure(:test, payload: {'hostname' => 'example.com'}) do |config|
        config.parameter :host, name: 'hostname'
      end

      expect(config.host).to eq('example.com')
    end
  end

  context 'with a required parameter' do
    it 'does not raise errors when all required fields are present' do
      expect {
        Isomer.configure(:test, payload: {'host' => 'example.com', 'timeout' => 100}) do |config|
          config.parameter :host, required: true
          config.parameter :timeout, required: true
        end
      }.to_not raise_error
    end

    it 'raises an error when any required field is not present' do
      expect {
        Isomer.configure(:test, payload: {'host' => 'example.com'}) do |config|
          config.parameter :host, required: true
          config.parameter :timeout, required: true
        end
      }.to raise_error(Isomer::RequiredParameterError, 'timeout is required')
    end
  end

  context 'with a default parameter' do
    it 'populates the configuration value with the default when no source value is present' do
      config = Isomer.configure(:test, payload: {}) do |config|
        config.parameter :timeout, default: 300
      end

      expect(config.timeout).to eq(300)
    end

    it 'populates the configuration value with source value when it is present' do
      config = Isomer.configure(:test, payload: {'timeout' => 100}) do |config|
        config.parameter :timeout, default: 300
      end

      expect(config.timeout).to eq(100)
    end
  end
end
