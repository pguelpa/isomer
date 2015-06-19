require 'spec_helper'

describe Isomer::Sources::Environment do
  describe '.new' do
    context 'with the convert case option' do
      it 'defaults to true' do
        expect(described_class.new.convert_case?).to be(true)
      end

      it 'respects the :convert_case option' do
        expect(described_class.new(convert_case: false).convert_case?).to be(false)
      end
    end
  end

  describe '#get' do
    it 'looks up the parameters from the environment' do
      source = described_class.new()

      expect(ENV).to receive(:[]).with('TOKEN')
      source.get('token')
    end

    context 'with convert case off' do
      it 'does not uppercase parameter names' do
        source = described_class.new(convert_case: false)

        expect(ENV).to receive(:[]).with('token')
        source.get('token')
      end
    end

    context 'with a prefix' do
      it 'appends the prefix when looking up the environment variable' do
        source = described_class.new(prefix: 'APP_')

        expect(ENV).to receive(:[]).with('APP_TOKEN')
        source.get('token')
      end
    end
  end
end
