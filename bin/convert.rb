# This script converts config.xml in order to upgrade jenkins-plugin-runtime
# from 0.1.17 to 0.2.3. This script also fixes JENKINS-18841.
#
# Usage: ruby migrate.rb jobs/project/config.xml

require 'fileutils'
require 'rexml/document'

def rewrite_proxy_class_name(proxy_object)
  proxy_object.elements.each('ruby-object') do |object|
    if object.attributes['ruby-class'] == 'Jenkins::Plugin::Proxies::BuildWrapper'
      object.attributes['ruby-class'] = 'Jenkins::Tasks::BuildWrapperProxy'
    end
  end
end

def remove_unwanted_serialized_attributes(proxy_object)
  proxy_object.elements.each('ruby-object') do |object|
    if object.attributes['pluginid'] == 'rvm'
      object.elements.each('object') do |obj|
        obj.elements.each do |attribute|
          obj.delete_element(attribute) unless attribute.name == 'impl'
        end
      end
    end
  end
end

def convert(config_file)
  new_config = nil
  File.open(config_file, 'r') do |file|
    doc = REXML::Document.new(file)
    doc.elements.each('*/buildWrappers/ruby-proxy-object') do |proxy_object|
      rewrite_proxy_class_name(proxy_object)
      remove_unwanted_serialized_attributes(proxy_object)
    end
    new_config = doc.to_s
  end
rescue => e
  $sterr.puts("Conversion failed: #{e.message}")
ensure
  new_config
end

unless ARGV[0]
  puts("Usage: #{$0} <config_file>")
  exit(-1)
end

new_config = convert(ARGV[0])
if new_config
  begin
    FileUtils.cp(ARGV[0], ARGV[0] + '.bak')
    File.open(ARGV[0], 'wb') { |f| f.puts(new_config) }
  rescue => e
    $stderr.puts(e.message)
    exit(-1)
  end
end
