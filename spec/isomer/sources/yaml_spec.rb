require 'spec_helper'

describe Isomer::Sources::Yaml do
  describe '.new' do
    it 'blows up if the file parameter is missing' do
      expect {
        Isomer::Sources::Yaml.new(anything)
      }.to raise_error(Isomer::Error, "YAML source requires the 'file' parameter")
    end

    it 'always converts the file to a string' do
      source = Isomer::Sources::Yaml.new(anything, file: :foo)
      source.file.should == 'foo'
    end
  end

  describe '#load' do
    it 'loads the YAML file configuration file' do
      File.stub(:exists?).and_return(true)
      YAML.should_receive(:load_file).with('/home/configuration.yml').and_return({'foo' => 'bar'})

      source = Isomer::Sources::Yaml.new(anything, file: '/home/configuration.yml')
      source.load

      source.configuration.should == {'foo' => 'bar'}
    end

    it 'returns an empty hash if the content is nil' do
      File.stub(:exists?).and_return(true)
      YAML.stub(:load_file).and_return(nil)

      source = Isomer::Sources::Yaml.new(anything, file: 'anything.yml')
      source.load

      source.configuration.should == {}
    end

    context 'when the file does not exist' do
      context 'when it is not required' do
        it 'does not blow up' do
          source = Isomer::Sources::Yaml.new(anything, file: '/home/configuration.yml')
          expect { source.load }.to_not raise_error
        end

        it 'sets the configuration to an empty hash' do
          source = Isomer::Sources::Yaml.new(anything, file: '/home/configuration.yml')
          source.load
          source.configuration.should == {}
        end
      end

      context 'when it is required' do
        it 'raises an error' do
          source = Isomer::Sources::Yaml.new(anything, file: '/home/configuration.yml', required: true)
          expect {
            source.load
          }.to raise_error(Isomer::Error, "Missing required configuration file '/home/configuration.yml'")
        end
      end
    end

    context 'with a base' do
      it 'returns the configuration under the base node' do
        File.stub(:exists?).and_return(true)
        YAML.stub(:load_file).and_return( 'production' => {'limit' => 100} )

        source = Isomer::Sources::Yaml.new(anything, file: 'filish.yml', base: 'production')
        source.load

        source.configuration.should == {'limit' => 100}
      end

      it 'returns an empty hash if the content is nil' do
        File.stub(:exists?).and_return(true)
        YAML.stub(:load_file).and_return( 'production' => nil )

        source = Isomer::Sources::Yaml.new(anything, file: 'filish.yml', base: 'production')
        source.load

        source.configuration.should == {}
      end
    end
  end
end
