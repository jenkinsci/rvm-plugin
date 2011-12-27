require 'stringio'

class RvmWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Run the build in a RVM-managed environment"

  attr_accessor :vm, :gemset

  def initialize(attrs)
    @vm = fix_empty attrs['vm']
    @gemset = fix_empty attrs['gemset']
  end

  def setup(build, launcher, listener)
    arg = vm
    arg += '@'+@gemset  if @gemset

    listener << "Capturing environment variables produced by 'rvm use #{arg}'\n"
    
    before = StringIO.new()
    if launcher.execute("bash","-c","export", {:out=>before})!=0 then
      listener << "Failed to fork bash"
      listener << before.string
      build.abort
    end

    after = StringIO.new()
    if launcher.execute("bash","-c","source ~/.rvm/scripts/rvm && rvm use --create #{arg} && export", {:out=>after})!=0 then
      listener << "Failed to 'rvm use #{arg}'"
      listener << after.string
      build.abort
    end

    bh = to_hash(before,listener)
    ah = to_hash(after,listener)
    ah.each do |k,v|
      bv = bh[k]

      next if k=="HUDSON_COOKIE" || k=="JENKINS_COOKIE" # cookie Jenkins uses to track process tree. ignore.
      next if bv==v  # no change in value

      if k=="PATH" then
        # look for PATH components that include ".rvm" and pick those up
        path = v.split(File::PATH_SEPARATOR).find_all{|p| p =~ /[\\\/]\.rvm[\\\/]/ }.join(File::PATH_SEPARATOR)
        build.env["PATH+RVM"] = path
        listener.debug "Adding PATH+RVM=#{path}"
      else
        listener.debug "Adding #{k}=#{v}"
        build.env[k] = v
      end
    end
  end

  private

  def fix_empty(s)
    s=="" ? nil : s
  end

  def to_hash(io,listener)
    r = {}
    io.string.split("\n").each do |l|
      if l.start_with? "declare -x " then
        l = l[11..-1]  # trim off "declare -x "
        k,v = l.split("=",2)
        if v then
          r[k] = (v[0]==?" || v[0]==?') ? v[1..-2] : v # trim off the quote surrounding it
        end
      end
    end
    r
  end
end