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
  end

  let(:wrapper) { described_class.new('impl' => '.') }
  let(:build) { double('build', native: '') }
  let(:launcher) { double('launcher') }
  let(:listener) { double('listener', native: '', :<< => '') }

  describe '#rvm_path' do
    context 'when rvm exists in ~/.rvm/scripts' do
      it 'should always test paths' do
        expect(launcher).to receive(:execute).with('bash', '-c', /\Atest -f ~\/.rvm\/scripts\/rvm\z/).twice.and_return(0)

        wrapper.instance_variable_set(:@launcher, launcher)

        2.times do
          expect(wrapper.rvm_path).to eq('~/.rvm/scripts/rvm')
        end
      end
    end
  end

  describe '#setup' do
    before do
      allow(TokenMacro).to receive(:expandAll)

      expect(launcher).to receive(:execute).with('bash', '-c', 'export', {:out => an_instance_of(StringIO)}).once.and_return(0)
    end

    context 'when rvm is not installed' do
      before do
        allow(launcher).to receive(:execute).with('bash', '-c', /\Atest -f/).exactly(4).and_return(-1)
        allow(launcher).to receive(:execute).with('bash', '-c', /\A source /, an_instance_of(Hash)).once.and_return(0)
      end

      context 'workspace is in path that contains space' do
        before do
          file_path = double('java.hudson.FilePath')
          allow(file_path).to receive(:+).and_return(file_path)
          allow(file_path).to receive(:chmod)
          allow(file_path).to receive(:copyFrom)
          allow(file_path).to receive(:native).and_return(file_path)
          allow(file_path).to receive(:read).and_return('')
          allow(file_path).to receive(:realpath).and_return('a b')
          allow(build).to receive(:workspace).and_return(file_path)
        end

        it 'should escape installer real path' do
          expect(launcher).to receive(:execute).with("a\\ b", {:out => anything})
          wrapper.setup(build, launcher, listener)
        end
      end
    end
  end
end
