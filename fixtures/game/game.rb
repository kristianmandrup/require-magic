require 'require-me'
puts Dir.pwd
puts __FILE__
Folder.enter_here(__FILE__) do
  Folder.require_me 'graphics/graphics'
end
puts "Game was included"