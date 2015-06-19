require 'spec_helper'

describe Isomer do
  describe '.configure' do
    before do
      Isomer::Base.stub(:from)
    end

    it 'yields the configuration to the class' do
      expect do |b|
        Isomer.configure(anything, {}, &b)
      end.to yield_control
    end

    it 'creates a new instance of the configuration class' do
      klass = double('Anonymous Class')
      allow(Class).to receive(:new).with(Isomer::Base).and_return(klass)

      expect(klass).to receive(:from).with(:foo, :bar).and_return(:baz)
      Isomer.configure(:foo, :bar).should == :baz
    end
  end
end
