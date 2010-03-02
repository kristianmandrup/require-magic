require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RequireMagic" do
  it "works" do
    Require.magic '../spec/fixtures' do |magic|
      magic.enter 'game' do |path|
        list = magic.require_all('**/*.rb')                                                    
        l1 = list.matching( 'sound', 'network').except(/sound/).show_require(:relative).inspect
        l1.should include("network/network.rb")

        l2 = list.matching( '*/sound', 'network').show_require(:relative).inspect        
        l2.should include("network/network.rb")
      end
    end    
  end
end
