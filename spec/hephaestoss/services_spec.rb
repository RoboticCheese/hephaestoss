require_relative '../spec_helper'
require_relative '../../lib/hephaestoss/services'

describe Hephaestoss::Services do
  let(:config) { nil }
  let(:services) do
    described_class.instance_variable_set(:@mapping, nil)
    described_class.configure!(config)
    described_class
  end

  describe '.configure!' do
    context 'no config' do
      let(:config) { nil }

      it 'uses the default path' do
        expected = File.expand_path('../../../data/services.json', __FILE__)
        # TODO: Having to type the .instance here is annoying
        expect(services.instance.path).to eq(expected)
      end
    end

    context 'a config with a specific JSON path' do
      let(:config) { { path: '/tmp/things.json' } }

      it 'uses the specified path' do
        # TODO: Having to type the .instance here is annoying
        expect(services.instance.path).to eq('/tmp/things.json')
      end
    end

    context 'a config with an unrecognized item' do
      let(:config) { { pathz: '/tmp/things.json' } }

      it 'raises an error' do
        expected = Hephaestoss::Exceptions::InvalidConfig
        expect { services }.to raise_error(expected)
      end
    end
  end

  describe '.[]' do
    let(:service) { nil }
    let(:res) { services[service] }

    { string: 'ssh', symbol: :ssh }.each do |k, v|
      context "a service represented as a #{k}" do
        let(:service) { v }

        it 'returns the expected service' do
          expect(res).to eq(tcp: [22])
        end
      end
    end
  end

  describe '.to_h' do
    before(:each) do
      allow(described_class).to receive(:mapping).and_return('mapping data')
    end

    it 'returns the result of the mapping method' do
      expect(services.to_h).to eq('mapping data')
    end
  end

  describe '.mapping' do
    shared_examples_for 'any config' do
      it 'loads the proper JSON file' do
        default = File.expand_path('../../../data/services.json', __FILE__)
        expect(File).to receive(:open).with(config && config[:path] || default)
          .and_call_original
        services.send(:mapping)
      end

      it 'returns a services hash' do
        expect(services.send(:mapping)).to be_an_instance_of(Hash)
        expect(services.send(:mapping)).to include(:ssh)
      end
    end

    context 'no config' do
      let(:config) { nil }

      it_behaves_like 'any config'
    end

    context 'a config with a specific JSON path' do
      let(:config) do
        { path: File.expand_path('../../support/data/services.json',
                                 __FILE__) }
      end

      it_behaves_like 'any config'

      it 'returns the expected hash' do
        expect(services.send(:mapping)).to eq(ssh: { tcp: [22] })
      end
    end
  end
end
