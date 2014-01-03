require 'spec_helper'
require 'rvm_wrapper'

describe RvmWrapper do
  describe '#initialize' do
    it { expect(described_class.new({}).impl).to eq('.') }
    it { expect(described_class.new('impl' => '').impl).to eq('.') }
    it { expect(described_class.new('impl' => '.').impl).to eq('.') }
  end

  describe 'transient properties' do
    it 'should make @launcher transient' do
      expect(described_class).to be_transient(:launcher)
      expect(described_class).to be_transient('launcher')
    end

    it 'should make @rvm_path transient' do
      expect(described_class).to be_transient(:rvm_path)
      expect(described_class).to be_transient('rvm_path')
    end
  end
end
