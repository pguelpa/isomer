require 'spec_helper'

describe Isomer::Base do
  let(:source) { double('Source', load: nil) }

  describe '.from' do
    let(:klass) { Class.new(Isomer::Base) }

    context 'with a source of :file' do
      it 'uses the yaml source' do
        Isomer::Sources::Yaml.
          should_receive(:new).
          with('/tmp/foo/bar.yml', nil).
          and_return(source)
        klass.from(:file, path: '/tmp/foo/bar.yml')
      end

      it 'passes along the base' do
        Isomer::Sources::Yaml.
          should_receive(:new).
          with(anything, 'production').
          and_return(source)
        klass.from(:file, path: anything, base: 'production')
      end
    end
  end

  describe '.parameter' do
    let(:klass) do
      Class.new(Isomer::Base) do
        parameter :basic
        parameter :with_default, default: 'foo'
        parameter :with_required, required: true
        parameter :with_name, name: :another_name
      end
    end
    let(:instance) { klass.from(:file, path: '/tmp/foo.yml') }

    before do
      instance = klass.from(:file, path: '/tmp/foo.yml')
      Isomer::Sources::Yaml.stub(:new).and_return(source)
    end

    it 'creates a method for the parameter' do
      source.should_receive(:for).with(:basic).and_return('Basic Param')
      instance.basic.should == 'Basic Param'
    end

    context 'with a default value specified' do
      context 'with no paramater from the source' do
        it 'returns the specified default' do
          source.should_receive(:for).with(:with_default).and_return(nil)
          instance.with_default.should == 'foo'
        end
      end

      context 'with a paramater from the source' do
        it 'returns the specified default' do
          source.should_receive(:for).with(:with_default).and_return('Got it covered')
          instance.with_default.should == 'Got it covered'
        end
      end
    end

    context 'with a required value' do
      it 'raises an Isomer::RequiredParameter exception' do
        source.should_receive(:for).with(:with_required).and_return(nil)
        expect {
          instance.with_required
        }.to raise_error(Isomer::RequiredParameterError, "'with_required' is a required parameter")
      end
    end

    context 'with a name parameter' do
      it 'returns the parameter with the given name' do
        source.should_receive(:for).with(:another_name).and_return('Mapped It!')
        instance.with_name.should == 'Mapped It!'
      end
    end
  end
end
