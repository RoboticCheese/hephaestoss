require_relative '../spec_helper'
require_relative '../../lib/hephaestoss/configurable'

describe Hephaestoss::Configurable do
  let(:test_class) do
    Class.new do
      include Hephaestoss::Configurable
    end
  end
  let(:config) { nil }
  let(:test_obj) { test_class.new(config) }

  describe '.included' do
    let(:base) { double }

    it 'extends ClassMethods' do
      expect(base).to receive(:extend).with(described_class::ClassMethods)
      described_class.included(base)
    end
  end

  describe '#initialize' do
    let(:test_class) do
      Class.new do
        include Hephaestoss::Configurable
        default_config :thing, nil
      end
    end

    shared_examples_for 'any config param' do
      it 'builds the config' do
        expect_any_instance_of(test_class).to receive(:build_config!)
        test_obj
      end

      it 'validates the config' do
        expect_any_instance_of(test_class).to receive(:validate_config!)
        test_obj
      end
    end

    context 'no config param' do
      let(:test_obj) { test_class.new }

      it_behaves_like 'any config param'

      it 'saves an empty/nil config hash' do
        expect(test_obj.config).to eq(thing: nil)
      end
    end

    context 'a nil config param' do
      let(:config) { nil }

      it_behaves_like 'any config param'

      it 'saves an empty/nil config hash' do
        expect(test_obj.config).to eq(thing: nil)
      end
    end

    context 'a populated config param' do
      let(:config) { { thing: 'stuff' } }

      it_behaves_like 'any config param'

      it 'saves the config hash' do
        expect(test_obj.config).to eq(config)
      end
    end
  end

  describe '#[]' do
    let(:test_class) do
      Class.new do
        include Hephaestoss::Configurable
        default_config :key1, 'value1'
        default_config :key2, nil
      end
    end

    it 'returns the correct value for non-nil config values' do
      expect(test_obj[:key1]).to eq('value1')
    end

    it 'returns nil for explicitly nil config values' do
      expect(test_obj[:key2]).to eq(nil)
    end

    it 'returns nil for unrecognized config values' do
      expect(test_obj[:key3]).to eq(nil)
    end
  end

  describe '#method_missing' do
    let(:test_class) do
      Class.new do
        include Hephaestoss::Configurable
        default_config :key1, 'value1'
        default_config :key2, nil
      end
    end

    it 'supports method access for non-nil config values' do
      expect(test_obj.key1).to eq('value1')
    end

    it 'supports method access for nil config values' do
      expect(test_obj.key2).to eq(nil)
    end

    it 'raises an error for unrecognized config values' do
      expect { test_obj.key3 }.to raise_error(NameError)
    end
  end

  describe '#build_config!' do
    let(:test_class) do
      Class.new do
        include Hephaestoss::Configurable
        default_config :key1, 'value1'
        default_config :key2, nil
        default_config :key3, nil
        exclusive_config :key2, :key3
      end
    end
    let(:config) { {} }

    before(:each) do
      allow_any_instance_of(test_class).to receive(:validate_config!)
    end

    context 'no overridden defaults' do
      let(:config) { {} }

      it 'returns the defaults' do
        expect(test_obj.config[:key1]).to eq('value1')
      end
    end

    context 'overridden defaults' do
      let(:config) { { key1: 'othervalue' } }

      it 'returns the overrides' do
        expect(test_obj.config[:key1]).to eq('othervalue')
      end
    end

    context 'two conflicting mutually exclusive config overrides' do
      let(:config) { { key2: 'val2', key3: 'val3' } }

      it 'raises an error' do
        expected = Hephaestoss::Exceptions::InvalidConfigCombination
        expect { test_obj }.to raise_error(expected)
      end
    end
  end

  describe '#validate_config!' do
    let(:test_class) do
      Class.new do
        include Hephaestoss::Configurable
        required_config :thing1
      end
    end

    context 'a valid config' do
      let(:config) { { thing1: 'test' } }

      it 'passes' do
        expect(test_obj.config[:thing1]).to eq('test')
      end
    end

    context 'an invalid config missing a required key' do
      let(:config) { {} }

      it 'raises an error' do
        expected = Hephaestoss::Exceptions::ConfigMissing
        expect { test_obj }.to raise_error(expected)
      end
    end

    context 'an invalid config with an unrecognized config key' do
      let(:config) { { thing2: 'bad' } }

      it 'raises an error' do
        expected = Hephaestoss::Exceptions::InvalidConfig
        expect { test_obj }.to raise_error(expected)
      end
    end
  end

  describe '#config' do
    it 'returns an empty Hash' do
      expect(test_obj.send(:config)).to eq({})
    end
  end

  describe described_class::ClassMethods do
    describe '.required_config' do
      let(:test_class) do
        Class.new do
          include Hephaestoss::Configurable
          required_config :key1
        end
      end

      it 'saves a required key for later' do
        expect(test_class.required).to eq([:key1])
      end
    end

    describe '.default_config' do
      let(:test_class) do
        Class.new do
          include Hephaestoss::Configurable
          default_config :key1, 'value1'
        end
      end

      it 'saves a default key and value for later' do
        expect(test_class.defaults).to eq(key1: 'value1')
      end
    end

    describe '.required' do
      context 'a fresh class' do
        it 'returns an empty Array' do
          expect(test_class.required).to eq([])
        end
      end

      context 'a class with some required items set' do
        let(:test_class) do
          Class.new do
            include Hephaestoss::Configurable
            required_config :test1
          end
        end

        it 'returns the required items' do
          expect(test_class.required).to eq([:test1])
        end
      end
    end

    describe '.defaults' do
      context 'a freshly initialized object' do
        it 'returns an empty Hash' do
          expect(test_class.defaults).to eq({})
        end
      end

      context 'an object with some defaults set' do
        let(:test_class) do
          Class.new do
            include Hephaestoss::Configurable
            default_config :thing1, 'test'
          end
        end

        it 'returns the defaults' do
          expect(test_class.defaults).to eq(thing1: 'test')
        end
      end
    end

    describe '.configure!' do
      it 'saves a new class instance in a class variable' do
        c = test_class
        expect(c.configure!).to be_an_instance_of(c)
      end
    end
  end
end
