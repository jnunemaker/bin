require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require File.expand_path('../lib/bin/version', __FILE__)

namespace :spec do
  Spec::Rake::SpecTask.new(:all) do |t|
    t.ruby_opts << '-rubygems'
    t.verbose = true
  end
end

desc 'Runs all specs against Active Support 2 and 3'
task :spec do
  sh "ACTIVE_SUPPORT_VERSION='<= 2.3.8' rake spec:all"
  sh "ACTIVE_SUPPORT_VERSION='>= 3.0.0.beta3' rake spec:all"
end

task :default => :spec

desc 'Builds the gem'
task :build do
  sh "gem build bin.gemspec"
end

desc 'Builds and installs the gem'
task :install => :build do
  sh "gem install bin-#{Bin::Version}"
end

desc 'Tags version, pushes to remote, and pushes gem'
task :release => :build do
  sh "git tag v#{Bin::Version}"
  sh "git push origin master"
  sh "git push origin v#{Bin::Version}"
  sh "gem push bin-#{Bin::Version}.gem"
end
