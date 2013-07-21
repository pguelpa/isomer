require 'spec_helper'

describe Isomer::Sources::Environment do
  let(:parameter) { double('Parameter', name: 'token') }

  describe '#load' do
    it 'looks up the parameters from the environment' do
      source = Isomer::Sources::Environment.new([parameter])

      ENV.should_receive(:[]).with('TOKEN')
      source.load
    end

    it 'stores all values in the configuration' do
      source = Isomer::Sources::Environment.new([parameter])

      ENV.stub(:[]).with('TOKEN').and_return('abcd-efgh')
      source.load
      source.configuration.should == {'token' => 'abcd-efgh'}
    end

    context 'with convert case off' do
      it 'does not uppercase parameter names' do
        source = Isomer::Sources::Environment.new([parameter], convert_case: false)

        ENV.should_receive(:[]).with('token')
        source.load
      end
    end

    context 'with a prefix' do
      it 'appends the prefix when looking up the environment variable' do
        source = Isomer::Sources::Environment.new([parameter], prefix: 'APP_')

        ENV.should_receive(:[]).with('APP_TOKEN')
        source.load
      end

      it 'respects the convert case flag' do
        source = Isomer::Sources::Environment.new([parameter], convert_case: false, prefix: 'app_')

        ENV.should_receive(:[]).with('app_token')
        source.load
      end
    end
  end
end