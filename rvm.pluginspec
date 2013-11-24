Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'rvm'
  plugin.version = '0.5'
  plugin.description = 'Run Jenkins builds in RVM'

  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/RVM+Plugin'
  plugin.developed_by 'kohsuke', 'kk@kohsuke.org'
  plugin.uses_repository :github => 'rvm-plugin'

  plugin.depends_on 'ruby-runtime', '0.10'
  plugin.depends_on 'token-macro', '1.5.1'
end
