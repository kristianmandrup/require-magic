require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RequireMagic" do
  it "works" do
    Folder.enter '../spec/fixtures' do |folder|
      folder.enter 'game' do |path|
        list = folder.all('**/*.rb')                                                    
        l1 = list.matching( 'sound', 'network').except(/sound/).do_require        
        l1_res = l1.show_require(:relative).inspect
        l1_res.should include("network/network.rb")

        l2 = list.matching( '*/sound', 'network').show_require(:relative).inspect        
        l2.should include("network/network.rb")
      end
    end    
  end

  it "works with base folder " do 
    Folder.enter do |folder|
      puts folder.current_path
      folder.enter 'game' do |path|
        list = folder.all # ('**/*.rb')                                                    
        l1 = list.matching( 'sound', 'network').except(/sound/).show_require(:relative).inspect        
        l1.should include("network/network.rb")
  
        l2 = list.matching( '*/sound', 'network').show_require(:relative).inspect        
        l2.should include("network/network.rb")
      end
    end    
  end  
  
  
end
