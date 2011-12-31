
module Jenkins
  class Plugin
    class Proxies
      # wrapper definition to be moved to jenkins-plugin-runtime
      class AxisDescriptorProxy < Java.hudson.matrix.AxisDescriptor
        include Jenkins::Model::RubyDescriptor
      end

      class AxisProxy < Java.hudson.matrix.Axis
        include Jenkins::Plugin::Proxies::Describable
        include Java.jenkins.ruby.Get
        include Jenkins::Plugin::Proxy

        def initialize(plugin, object)
          super(plugin, object, object.name, object.values)
        end
      end
    end
  end
end

class Axis
  include Jenkins::Model
  include Jenkins::Model::Describable

  describe_as Java.hudson.matrix.Axis
  descriptor_is Jenkins::Plugin::Proxies::AxisDescriptorProxy

  attr_reader :name, :values

  #
  # @param [String] name
  #     the axis name
  # @param [Array<String>,String] values
  #     values of this axis, either pre-split single string or post-split multiple strings
  def initialize(name,values)
    @name = name
    if String === values then
      @values = values.split(/[ \t\r\n]+/)
    else
      @values = values
    end

    puts "name=#{name}"
    puts "values=#{values}"
  end

  Jenkins::Plugin::Proxies::register self, Jenkins::Plugin::Proxies::AxisProxy
end



# actual implementation
class RvmAxis < Axis
  display_name "RVM"

  def initialize(attrs)
    super("RVM",fix_empty(attrs['valueString']))
  end

private
  def fix_empty(s)
    s=="" ? nil : s
  end
end
