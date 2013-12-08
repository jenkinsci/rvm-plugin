require 'spec_helper'
require 'rvm_wrapper'

describe RvmWrapper do
  describe '#initialize' do
    it { expect(described_class.new({}).impl).to eq('.') }
    it { expect(described_class.new('impl' => '').impl).to eq('.') }
    it { expect(described_class.new('impl' => '.').impl).to eq('.') }
  end
end
