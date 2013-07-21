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
  end
end