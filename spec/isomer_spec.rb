require 'spec_helper'

describe Isomer do
  describe '.configure' do
    around :all do |example|
      # Turn off deprecation warnings for tests
      Gem::Deprecate.skip_during { example.run }
    end

    before do
      allow(Isomer::Base).to receive(:from)
    end

    it 'yields the configuration to the class' do
      expect do |b|
        Isomer.configure(anything, {}, &b)
      end.to yield_control
    end

    it 'creates a new instance of the configuration class' do
      klass = double('Anonymous Class')
      allow(Class).to receive(:new).with(Isomer::Base).and_return(klass)

      expect(klass).to receive(:from).with(:foo, :bar)
      Isomer.configure(:foo, :bar)
    end
  end
end
