require_relative '../spec_helper'
require_relative '../../lib/hephaestoss/subnets'

describe Hephaestoss::Subnets do
  let(:config) { nil }
  let(:subnets) do
    described_class.configure!(config)
    described_class
  end

  describe '.configure!' do
    context 'no config' do
      let(:config) { nil }

      it 'uses the default path' do
        expected = File.expand_path('../../../data/subnets.json', __FILE__)
        expect(subnets.config[:path]).to eq(expected)
      end
    end

    context 'a config with a specific JSON path' do
      let(:config) do
        { path: File.expand_path('../../support/data/subnets.json', __FILE__) }
      end

      it 'uses the specified path' do
        expected = File.expand_path('../../support/data/subnets.json', __FILE__)
        expect(subnets.config[:path]).to eq(expected)
      end
    end

    context 'a config with an unrecognized item' do
      let(:config) { { pathz: '/tmp/things.json' } }

      it 'raises an error' do
        expected = Hephaestoss::Exceptions::InvalidConfig
        expect { subnets }.to raise_error(expected)
      end
    end
  end

  describe '.[]' do
    let(:config) do
      { path: File.expand_path('../../support/data/subnets.json', __FILE__) }
    end

    it 'returns the expected subnet' do
      expect(subnets[:test][:all]).to eq(%w(0.0.0.0/0))
    end
  end

  describe '.to_h' do
    before(:each) do
      allow(described_class).to receive(:mapping).and_return('mapping data')
    end

    it 'returns the result of the mapping method' do
      expect(subnets.to_h).to eq('mapping data')
    end
  end

  describe '.mapping' do
    shared_examples_for 'any config' do
      it 'loads the proper JSON file' do
        default = File.expand_path('../../../data/subnets.json', __FILE__)
        expect(File).to receive(:open).with(config && config[:path] || default)
          .and_call_original
        subnets.send(:mapping)
      end

      it 'returns a subnets hash' do
        expect(subnets.send(:mapping)).to be_an_instance_of(Hash)
      end
    end

    context 'no config' do
      let(:config) { nil }

      it_behaves_like 'any config'
    end

    context 'a config with a specific JSON path' do
      let(:config) do
        { path: File.expand_path('../../support/data/subnets.json',
                                 __FILE__) }
      end

      it_behaves_like 'any config'

      it 'returns the expected hash' do
        expect(subnets.send(:mapping)).to eq(test: { all: %w(0.0.0.0/0) })
      end
    end
  end
end
