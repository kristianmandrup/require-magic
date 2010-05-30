require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "RequireMagic" do
  it "Folder.enter works " do          
    Folder.enter '..' do   
      Folder.enter '../fixtures/game' do |folder|            
        # puts "Current 1:" + folder.current_path          
      end
      Folder.enter('../fixtures/game') do |folder|            
        # puts "Current 2:" + folder.current_path          
      end
    end
  end
  
  it "just works " do          
    Folder.enter '../../fixtures' do |folder| # oops!
      folder.enter 'game' do |f|
        list = f.all_recursive #('**/*.rb')                                                    
        l1 = list.matching( 'sound', 'network').except(/sound/)
  
        # require fx 'game/network/network.rb'
        l1.do_require(f.me)
                
        l1_res = l1.show_require(:relative).inspect
        l1_res.should include("network/network.rb")
  
        l2 = list.matching( '*/sound', 'network').show_require(:relative).inspect        
        l2.should include("network/network.rb")
      end
    end    
  end
  
  it "works with require_all " do          
    Folder.enter('../../fixtures/game') do |folder|            
      folder.require_all 'graphics', 'network', 'sound'
    end
  end
  
  it "works with require_all and explicit :relative_to" do          
    Folder.enter('../../fixtures/game') do |folder|            
      folder.require_all 'graphics', 'network', 'sound', :relative_to => folder.me
    end
  end
    
  
  it "works with require_all and require me" do          
    Folder.enter '..' do    
      Folder.enter '../fixtures/game' do |f|
        f.require_all
        f.require_me 'game.rb'
      end            
    end
  end  
  
  it "works with require_all " do          
    Folder.require_all '../../fixtures' 
  end
  
  it "works with require_rel " do          
    Folder.require_spec 'blip', __FILE__     

    Folder.require_all_here __FILE__

    Folder.require_rel 'blap', __FILE__ , 'dsl' 
    
    Folder.require_rel 'spec/blip', __FILE__ 
    Folder.require_rel 'blip', __FILE__ , 'spec' 

    # puts Folder.relative_path 'blip', __FILE__ , 'spec' 
  
    Folder.rel_base 'spec', __FILE__ do |f|
      f.require_me 'blip'      
    end    
  end 
  
    
  it "works with base folder " do  
    Folder.enter '..' do       
      Folder.enter '../fixtures' do |folder|
        # puts "Current 2:" + folder.current_path
        folder.enter 'game' do |f|
          f.relative_to_me # set implicit by default          
          
          f.require_all_recursive        
          list = f.all_recursive # ('**/*.rb')                                                    
          l1 = list.matching( 'sound', 'network').except(/sound/).show_require(:relative).inspect        
          l1.should include("network/network.rb")
  
          l2 = list.matching( '*/sound', 'network').show_require(:relative).inspect        
          l2.should include("network/network.rb")                      
        end
      end    
    end
  end    
  
end
