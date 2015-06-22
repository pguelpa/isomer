require 'spec_helper'

describe Isomer::Sources do
  describe '.factory' do
    context 'with a source of :yaml' do
      it 'uses the yaml source' do
        expect(Isomer::Sources::Yaml).to receive(:new).with('/tmp/foo/bar.yml', base: 'development')

        Isomer::Sources.factory(:yaml, [], file: '/tmp/foo/bar.yml', base: 'development')
      end
    end

    context 'with a source of :environment' do
      it 'uses the environment source' do
        expect(Isomer::Sources::Environment).to receive(:new).with(prefix: 'APP_')

        Isomer::Sources.factory(:environment, [], prefix: 'APP_')
      end
    end

    context 'with a source of :test' do
      it 'uses the Hash source with the payload' do
        expect(Isomer::Sources::Dictionary).to receive(:new).with('news' => 'BBC')

        Isomer::Sources.factory(:test, [], payload: {'news' => 'BBC'})
      end
    end
  end
end
