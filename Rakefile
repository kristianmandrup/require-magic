require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "require-magic"
    gem.summary = %Q{utility to facilitate require of .rb files and folders}
    gem.description = %Q{enhance your ruby app with require magic to more easily define how to include hierarchies of ruby files, and also apply inclusion/exclusion filters for what to include}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/require-magic"
    gem.authors = ["Kristian Mandrup"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.files.exclude 'test'        
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

