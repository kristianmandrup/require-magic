require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RequireMagic" do
  it "Folder.enter works " do          
    puts FileUtils.pwd
    Folder.enter 'fixtures/game' do |folder|            
      puts "Current 1:" + folder.current_path          
    end
    Folder.enter('fixtures/game') do |folder|            
      puts "Current 2:" + folder.current_path          
    end
  end

  it "just works " do          
    Folder.enter 'fixtures' do |folder| # oops!
      folder.enter 'game' do |f|
        puts f
        list = folder.all('**/*.rb')                                                    
        l1 = list.matching( 'sound', 'network').except(/sound/).do_require        
        l1_res = l1.show_require(:relative).inspect
        l1_res.should include("network/network.rb")
  
        l2 = list.matching( '*/sound', 'network').show_require(:relative).inspect        
        l2.should include("network/network.rb")
      end
    end    
  end
  
  it "works with require_all " do          
    Folder.enter('fixtures/game') do |folder|            
      puts "Current 1:" + folder.current_path    
      folder.require_all 'graphics', 'network', 'sound'
    end
  end

  it "works with require_all " do          
    Folder.enter 'fixtures' do |f|
      f.require_all
    end            
  end

  it "works with require_all " do          
    Folder.require_all 'fixtures' 
  end

  
  it "works with base folder " do  
    Folder.enter 'fixtures' do |folder|
      puts "Current 2:" + folder.current_path
      folder.enter 'game' do |f|
        puts f
        f.require_all        
        list = f.all # ('**/*.rb')                                                    
        l1 = list.matching( 'sound', 'network').except(/sound/).show_require(:relative).inspect        
        l1.should include("network/network.rb")
  
        l2 = list.matching( '*/sound', 'network').show_require(:relative).inspect        
        l2.should include("network/network.rb")                      
      end
    end    
  end    
  
end
