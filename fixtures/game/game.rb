require 'require-me'
Folder.enter_here(__FILE__) do
  Folder.require_me 'graphics/graphics'
  Require.folders 'network', 'sound'
end
puts "Game was included"