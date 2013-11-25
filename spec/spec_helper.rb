Dir['spec/support/lib/*.jar'].each { |jar| require jar }
$CLASSPATH << 'spec/support/classes/'

require 'bundler/setup'
Bundler.require

$: << File.expand_path(File.join(*%w{.. .. models}), __FILE__)
