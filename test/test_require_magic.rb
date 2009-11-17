require 'require-magic'
require "test/unit"
 
class TestFilter < Test::Unit::TestCase

  def setup
    @folders = ['data', 'data2']
  end

  def teardown
    ## Nothing really
  end
    
  def test_require_folders
    required_files = Require.folders(@folders)
    found = !(required_files[0] =~ /data2\/blap_a.rb/).nil?
    assert_equal true, found, "Should require blap_a.rb in /data" 
  end

  def test_require_folders_recursive
    options = {:recursive => true}
    required_files = Require.folders(@folders, options)
    assert_equal 3, required_files.size, "Should require 3 files" 
  end

  def test_require_folders_recursive
    options = {:recursive => true, :include => 'blip_'}
    required_files = Require.folders(@folders, options)
    assert_equal 2, required_files.size, "Should require 2 files" 
  end

  def test_require_folders_recursive
    options = {:recursive => true, :exclude => 'blip_'}
    required_files = Require.folders(@folders, options)
    assert_equal 2, required_files.size, "Should require 2 file" 
  end  

  def test_require_folders_recursive
    options = {:folders => ['blip']}
    required_files = Require.folders(@folders, options)
    assert_equal 3, required_files.size, "Should require 3 files" 
  end  
  
end

