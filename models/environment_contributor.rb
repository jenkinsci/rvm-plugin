class RvmEnvironmentContributor < Jenkins::Model::EnvironmentContributor
  Java.hudson.model.AbstractItem.class_eval do
    field_accessor({:parent => :safe_parent})
  end

  def build_environment_for(run,env,listener)
    puts "build_environment_for(#{run})"
    r = run.native
    if r.is_a? Java.hudson.matrix.MatrixRun then
      config = r.parent
      if config.safe_parent.axes.find("RVM") then
        val = config.combination.get("RVM")
        launcher = run.workspace.create_launcher(listener)
        RvmWrapper.new({"impl" => val}).setup(run, launcher, listener)
      end
    end
  end
end