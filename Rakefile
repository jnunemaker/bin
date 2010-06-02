require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require File.expand_path('../lib/bin/version', __FILE__)

Spec::Rake::SpecTask.new do |t|
  t.ruby_opts << '-rubygems'
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
