require 'spec_helper'

describe Isomer::Sources do
  describe '.factory' do
    context 'with a source of :yaml' do
      it 'uses the yaml source' do
        Isomer::Sources::Yaml.
          should_receive(:new).
          with('/tmp/foo/bar.yml', nil)

        Isomer::Sources.factory(:yaml, path: '/tmp/foo/bar.yml')
      end

      it 'passes along the base' do
        Isomer::Sources::Yaml.
          should_receive(:new).
          with(anything, 'production')

        Isomer::Sources.factory(:yaml, path: anything, base: 'production')
      end
    end
  end
end