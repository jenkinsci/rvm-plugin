require 'rack'

class ModelReloadRootAction < Jenkins::Model::RootAction
  display_name 'Reload Ruby plugins'
  icon 'refresh.png'
  url_path 'reload_ruby_plugins'

  def call(env)
    # TODO: add to Jenkins::Plugin
    Jenkins::Plugin.instance.instance_eval do
      @peer.getExtensions().clear
    end
    Jenkins::Plugin.instance.load_models
    puts "reloaded"
  end
end

reload = ModelReloadRootAction.new
Jenkins::Plugin.instance.register_extension(reload)
