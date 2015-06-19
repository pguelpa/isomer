require 'spec_helper'

describe Isomer::Nucleus do
  describe '.build' do
    it 'return an instance of a nucleus' do
      expect(described_class.build).to be_a(Isomer::Nucleus)
    end

    it 'builds a set from the defined parameters' do
      config = described_class.build { |c| c.parameter :tails }
      expect(config.parameters[:tails]).to be_a(Isomer::Parameter)
    end
  end

  describe '#parameter' do
    it 'builds a parameter' do
      parameter = instance_double(Isomer::Parameter)
      expect(Isomer::Parameter).to receive(:new).with(:email, default: true, other_option: 10).and_return(parameter)
      nucleus = described_class.new

      nucleus.parameter(:email, default:true, other_option: 10)
    end

    it 'adds the parameter to this configuration\'s parameters' do
      parameter = instance_double(Isomer::Parameter)
      allow(Isomer::Parameter).to receive(:new).and_return(parameter)
      nucleus = described_class.new
      nucleus.parameter(:name)

      expect(nucleus.parameters[:name]).to eq(parameter)
    end
  end
end
