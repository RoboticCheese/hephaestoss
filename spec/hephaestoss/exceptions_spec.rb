require_relative '../spec_helper'
require_relative '../../lib/hephaestoss/exceptions'

describe Hephaestoss::Exceptions do
  describe Hephaestoss::Exceptions::ConfigMissing do
    describe '#initialize' do
      it 'complains about a missing key' do
        expected = '`key1` config key cannot be nil'
        expect(described_class.new(:key1).message).to eq(expected)
      end
    end
  end

  describe Hephaestoss::Exceptions::InvalidConfig do
    describe '#initialize' do
      it 'complains about an invalid key' do
        expected = '`key1` is not a valid config key'
        expect(described_class.new(:key1).message).to eq(expected)
      end
    end
  end

  describe Hephaestoss::Exceptions::InvalidConfigCombination do
    describe '#initialize' do
      it 'complains about an invalid key combination' do
        expected = "The `[:key1, :key2]` config keys are mutually exclusive"
        expect(described_class.new([:key1, :key2]).message).to eq(expected)
      end
    end
  end
end
