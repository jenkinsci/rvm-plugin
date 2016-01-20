Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'rvm-escaped'
  plugin.version = '0.5'
  plugin.description = 'Run Jenkins builds in RVM'

  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Rvm+Escaped+Plugin'
  plugin.developed_by 'kohsuke', 'kk@kohsuke.org'
  plugin.uses_repository :github => 'rvm-plugin'

  plugin.depends_on 'ruby-runtime', '0.12'
  plugin.depends_on 'token-macro', '1.9'
end
