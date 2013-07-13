require 'spec_helper'

describe Isomer::Base do
  let(:source) { double('Source', load: nil) }

  describe '.from' do
    let(:klass) { Class.new(Isomer::Base) }

    context 'with a source of :yaml' do
      it 'uses the yaml source' do
        Isomer::Sources::Yaml.
          should_receive(:new).
          with('/tmp/foo/bar.yml', nil).
          and_return(source)
        klass.from(:yaml, path: '/tmp/foo/bar.yml')
      end

      it 'passes along the base' do
        Isomer::Sources::Yaml.
          should_receive(:new).
          with(anything, 'production').
          and_return(source)
        klass.from(:yaml, path: anything, base: 'production')
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

    let(:instance) do
      payload = {
        'basic' => 'Basic Param',
        'with_default' => 'Got it covered',
        'with_required' => 'Oh Yeah!',
        'another_name' => 'Mapped It!'
      }
      klass.from(:test, payload: payload)
    end

    it 'creates a method for the parameter' do
      instance.basic.should == 'Basic Param'
    end

    context 'with a default value specified' do
      context 'with no value from the source' do
        it 'returns the specified default' do
          instance.source.payload.delete('with_default')
          instance.with_default.should == 'foo'
        end
      end

      context 'with a value from the source' do
        it 'returns the specified default' do
          instance.with_default.should == 'Got it covered'
        end
      end
    end

    context 'with a required value' do
      context 'with no value from the source' do
        it 'raises an Isomer::RequiredParameter exception' do
          instance.source.payload.delete('with_required')
          expect {
            instance.with_required
          }.to raise_error(Isomer::RequiredParameterError, "'with_required' is a required parameter")
        end
      end

      context 'with a value from the source' do
        it 'returns the value' do
          instance.with_required.should == 'Oh Yeah!'
        end
      end
    end

    context 'with a named parameter' do
      it 'returns the parameter with the given name' do
        instance.with_name.should == 'Mapped It!'
      end
    end
  end
end
