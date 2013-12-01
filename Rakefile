begin
  require 'jenkins/rake'

  Jenkins::Rake.install_tasks
rescue LoadError
  #
end

begin
  require 'rspec/core/rake_task'

  spec_task = RSpec::Core::RakeTask.new

  task :default => spec_task.name
rescue LoadError
  #
end
