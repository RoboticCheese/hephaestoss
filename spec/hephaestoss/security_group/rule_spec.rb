require_relative '../../spec_helper'
require_relative '../../../lib/hephaestoss/security_group/rule'

describe Hephaestoss::SecurityGroup::Rule do
  let(:config) { nil }
  let(:rule) { described_class.new(config) }

  describe '#initialize' do
    shared_examples_for 'a config item missing' do
      it 'raises an error' do
        expect { rule }.to raise_error(Hephaestoss::Exceptions::ConfigMissing)
      end
    end

    shared_examples_for 'an invalid config combination' do
      it 'raises an error' do
        expected = Hephaestoss::Exceptions::InvalidConfigCombination
        expect { rule }.to raise_error(expected)
      end
    end

    context 'no config' do
      let(:config) { nil }

      it_behaves_like 'a config item missing'
    end

    context 'a minimal valid config' do
      let(:config) { { port: 80, cidr: '0.0.0.0/0' } }

      it 'uses the default protocol' do
        expect(rule.protocol).to eq('tcp')
      end

      it 'correctly parses the from_port' do
        expect(rule.from_port).to eq(80)
      end

      it 'correctly parses the to_port' do
        expect(rule.to_port).to eq(80)
      end

      it 'uses the specified CIDR range' do
        expect(rule.cidr).to eq('0.0.0.0/0')
      end
    end

    context 'a config with a specific protocol' do
      let(:config) do
        { port: 80, protocol: 'udp', cidr: '0.0.0.0/0' }
      end

      it 'uses the specified protocol' do
        expect(rule.protocol).to eq('udp')
      end

      it 'correctly parses the from_port' do
        expect(rule.from_port).to eq(80)
      end

      it 'correctly parses the to_port' do
        expect(rule.to_port).to eq(80)
      end

      it 'uses the specified CIDR range' do
        expect(rule.cidr).to eq('0.0.0.0/0')
      end
    end

    context 'a config with port "all"' do
      let(:config) do
        { port: 'all', protocol: 'tcp', cidr: '0.0.0.0/0' }
      end

      it 'uses the specified protocol' do
        expect(rule.protocol).to eq('tcp')
      end

      it 'correctly parses the from_port' do
        expect(rule.from_port).to eq(0)
      end

      it 'correctly parses the to_port' do
        expect(rule.to_port).to eq(65_535)
      end

      it 'uses the specified CIDR range' do
        expect(rule.cidr).to eq('0.0.0.0/0')
      end
    end

    context 'a config item missing any port information' do
      let(:config) { { cidr: '0.0.0.0/0' } }

      it_behaves_like 'a config item missing'
    end

    context 'a config with a from_port but missing a to_port' do
      let(:config) { { from_port: 80, cidr: '0.0.0.0/0' } }

      it_behaves_like 'a config item missing'
    end

    context 'a config with a to_port but missing a from_port' do
      let(:config) { { to_port: 80, cidr: '0.0.0.0/0' } }

      it_behaves_like 'a config item missing'
    end

    context 'a config with both a port and from_port' do
      let(:config) { { port: 80, from_port: 80, cidr: '0.0.0.0/0' } }

      it_behaves_like 'an invalid config combination'
    end

    context 'a config with both a port and to_port' do
      let(:config) { { port: 80, to_port: 80, cidr: '0.0.0.0/0' } }

      it_behaves_like 'an invalid config combination'
    end

    context 'a config item missing any CIDR information' do
      let(:config) { { port: 80 } }

      it_behaves_like 'a config item missing'
    end
  end

  describe '#to_h' do
    let(:config) { { port: 80, cidr: '0.0.0.0/0' } }

    it 'returns an AWS-formatted ingress rule hash' do
      expected = {
        CidrIp: '0.0.0.0/0',
        FromPort: 80,
        ToPort: 80,
        IpProtocol: 'tcp'
      }
      expect(rule.to_h).to eq(expected)
    end
  end
end
