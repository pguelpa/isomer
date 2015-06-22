require 'spec_helper'

describe Isomer::Sources::Yaml do
  describe '#get' do
    context 'when the file exists' do
      before do
        allow(File).to receive(:exists?).and_return(true)
      end

      it 'only loads the file once' do
        expect(YAML).to receive(:load_file).with('/home/configuration.yml').once.and_return({})

        source = described_class.new('/home/configuration.yml')
        2.times { source.get('foo') }
      end

      context 'when file does not load into a hash' do
        it 'returns nil for configuration parameters' do
          allow(YAML).to receive(:load_file).and_return('string value')
          source = described_class.new('anything.yml')

          expect(source.get('foo')).to be_nil
        end
      end

      context 'when the file loads as a hash' do
        it 'returns configuration values from corresponding hash parameters' do
          allow(YAML).to receive(:load_file).and_return({'foo' => 'bar'})
          source = described_class.new('anything.yml')

          expect(source.get('foo')).to eq('bar')
        end

        it 'returns nil if the corresponding hash parameter does not exist' do
          allow(YAML).to receive(:load_file).and_return({})
          source = described_class.new('anything.yml')

          expect(source.get('foo')).to be_nil
        end

        context 'with a base' do
          it 'returns configuration values from corresponding hash parameters under the base node' do
            allow(YAML).to receive(:load_file).and_return('production' => {'limit' => 100})
            source = described_class.new(anything, base: 'production')

            expect(source.get('limit')).to eq(100)
          end

          it 'returns nil if the corresponding hash parameter does not exist under the base node' do
            allow(YAML).to receive(:load_file).and_return('production' => {})
            source = described_class.new(anything, base: 'production')

            expect(source.get('foo')).to be_nil
          end
        end
      end
    end

    context 'when the file does not exist' do
      before do
        allow(File).to receive(:exists?).and_return(false)
      end

      context 'when it is not required' do
        it 'does not blow up' do
          source = described_class.new('anything.yml')
          expect { source.get(anything) }.to_not raise_error
        end

        it 'returns nil for configuration values' do
          source = described_class.new('anything.yml')
          expect(source.get('anything')).to be_nil
        end
      end

      context 'when it is required' do
        it 'raises an error' do
          source = described_class.new('/home/configuration.yml', required: true)

          expect {
            source.get(anything)
          }.to raise_error(Isomer::Error, "Missing required configuration file '/home/configuration.yml'")
        end
      end
    end
  end
end
