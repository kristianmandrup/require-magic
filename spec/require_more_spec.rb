require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "static folder functions" do
  it "show work with here" do          
    Folder.here(__FILE__).require_me '../fixtures/game/game.rb'
  end

  it "show work with require_me" do          
    Folder.require_me '../fixtures/game/game.rb'  
  end               
    
end
