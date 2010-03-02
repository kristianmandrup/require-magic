require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RequireMagic" do
  it "works" do
    Require.magic '../spec/fixtures' do |magic|
      magic.enter 'game' do |path|
        list = magic.require_all('**/*.rb')    
        puts list.matching( 'sound', 'network').except(/sound/).show_require(:relative).inspect.should include("network/network.rb")
      end
    end    
  end
end
