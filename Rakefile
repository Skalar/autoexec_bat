#!/usr/bin/env rake
require "bundler/gem_tasks"

desc 'Compile coffee source to JavaScript (requires coffee binary)'
task :compile do
  `coffee -o . lib/assets/javascripts/autoexec_bat.coffee`
end

desc 'Test'
task :test do
  system "mocha -R spec"
end
