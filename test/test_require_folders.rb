require 'require-magic'
require "unit_test_require"
 
class TestRequireFolders < UnitTestRequire
    
  def test_require_folders
    required_files = Require.folders(@folders)
    
    found0 = match? required_files[0], 'data_a.rb'
    found1 = match? required_files[1], 'data2/blap_a.rb'
      
    assert_equal 2, required_files.size, "Should require 2 files" 
    assert found0, "Should require data_a.rb in /" 
    assert found1, "Should require blap_a.rb in /data" 
  end
  
  def test_require_folders_recursive
    options = {:recursive => true}
    required_files = Require.folders(@folders, options)
    assert_equal 5, required_files.size, "Should require 5 files" 
  end
  
  def test_require_folders_recursive_include
    options = {:recursive => true, :include => 'blip_'}
    required_files = Require.folders(@folders, options)
    assert_equal 2, required_files.size, "Should require 2 files" 
  end
  
  def test_require_folders_recursive_exclude
    options = {:recursive => true, :exclude => 'blip_'}
    required_files = Require.folders(@folders, options)
    assert_equal 3, required_files.size, "Should require 3 file" 
  end  
  
  def test_require_folders_recursive_default
    options = {:folders => ['blip']}
    required_files = Require.folders(@folders, options)
    assert_equal 4, required_files.size, "Should require 4 files" 
    
    found0 = match? required_files[0], 'data_a.rb'    
    assert found0, "Should require root files such as 'data_a.rb' first"     
  end  

  
end

