require 'spec_helper'

describe Isomer::Sources::Yaml do
  describe '#load' do
    it 'loads the YAML file configuration file' do
      File.stub(:exists?).and_return(true)
      YAML.should_receive(:load_file).with('/home/configuration.yml').and_return({'foo' => 'bar'})

      source = Isomer::Sources::Yaml.new('/home/configuration.yml')
      source.load

      source.configuration.should == {'foo' => 'bar'}
    end

    it 'does not raise if the file does not exist' do
      source = Isomer::Sources::Yaml.new('/home/configuration.yml')
      expect { source.load }.to_not raise_error
    end

    context 'with a base' do
      it 'returns the configuration under the base node' do
        File.stub(:exists?).and_return(true)
        YAML.stub(:load_file).and_return( 'production' => {'limit' => 100} )

        source = Isomer::Sources::Yaml.new(anything, 'production')
        source.load

        source.configuration.should == {'limit' => 100}
      end
    end
  end
end
