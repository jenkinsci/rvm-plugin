Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'rvm'
  plugin.version = '0.1'
  plugin.description = 'Run Jenkins builds in RVM'

  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/RVM+Plugin'
  plugin.developed_by 'kohsuke', 'kk@kohsuke.org'

  plugin.depends_on 'ruby-runtime', '0.7'
end
