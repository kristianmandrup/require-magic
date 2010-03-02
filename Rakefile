# encoding: utf-8 

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "require-magic"
    gem.summary = %Q{Facilitates requiring select ruby files in folders}
    gem.description = %Q{Lets you easily define how to include hierarchies of ruby files, and also apply inclusion/exclusion filters for what to include}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/require-magic"
    gem.authors = ["Kristian Mandrup"]
    # gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.files.exclude 'test', 'spec'
    gem.files = FileList['lib/**/*.rb']
    # gem.add_dependency 
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end             


