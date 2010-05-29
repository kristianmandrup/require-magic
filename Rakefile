# encoding: utf-8 

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "require-me"
    gem.summary = %Q{Facilitates requiring select ruby files in folders}
    gem.description = %Q{Lets you easily define how to include hierarchies of ruby files, and also apply inclusion/exclusion filters for what to include}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/require-magic"
    gem.authors = ["Kristian Mandrup"]
    gem.files.exclude 'test', 'spec'
    gem.files = FileList['lib/**/*.rb']
    gem.add_development_dependency 'load-me', '>= 0.1.0'
    gem.add_development_dependency "rspec", ">= 2.0.0"
  end
  # Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end             


