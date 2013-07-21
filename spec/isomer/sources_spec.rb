require 'spec_helper'

describe Isomer::Sources do
  describe '.factory' do
    context 'with a source of :yaml' do
      it 'uses the yaml source' do
        Isomer::Sources::Yaml.
          should_receive(:new).
          with([], path: '/tmp/foo/bar.yml', base: 'development')

        Isomer::Sources.factory(:yaml, [], path: '/tmp/foo/bar.yml', base: 'development')
      end
    end

    context 'with a source of :environment' do
      it 'uses the environment source' do
        Isomer::Sources::Environment.
          should_receive(:new).
          with([], prefix: 'APP_')

        Isomer::Sources.factory(:environment, [], prefix: 'APP_')
      end
    end

    context 'with a source of :test' do
      it 'uses the test source' do
        Isomer::Sources::Test.
          should_receive(:new).
          with([], payload: {})

        Isomer::Sources.factory(:test, [], payload: {})
      end
    end
  end
end