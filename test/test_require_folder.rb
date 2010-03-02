require 'require-magic'
require "unit_test_require"
 
class TestRequireFolder < UnitTestRequire
    
  def test_require_folder
    required_files = Require.folder(@folder)
        
    found0 = match? required_files[0], 'data_a.rb'
      
    assert_equal 1, required_files.size, "Should require 1 file" 
    assert found0, "Should require data_a.rb in /" 
  
  end
  
  def test_require_folder_recursive
    required_files = Require.rfolder(@folder)
    assert_equal 4, required_files.size, "Should require 4 files" 
  end
  
  def test_require_folder_recursive_include
    options = {:include => '_a'}
    required_files = Require.folder(@folder, options)
    assert_equal 1, required_files.size, "Should require 1 file" 
  end

  def test_require_folder_recursive_include_base_path
    options = {:include => '_a'}
    Require.base_path = File.dirname(__FILE__) + "/../lib"
    required_files = Require.folder(@folder, options)
    
    assert_equal 1, required_files.size, "Should require 1 file" 
    assert_equal "/data/data_a.rb", required_files[0], "Path of required files should be from base_path when verbose not :on"
  end

  
  def test_require_folders_recursive_exclude_base_path
    options = {:exclude => '_a'}
    required_files = Require.folder(@folder, options)
    assert_equal 0, required_files.size, "Should require 0 files" 
  end  
  
  def test_require_folder_recursive_default_base_path_override
    options = {:folders => ['blip'], :base_path => File.dirname(__FILE__) + "/../lib"}
    required_files = Require.folder(@folder, options)
    
    assert_equal 3, required_files.size, "Should require 3 files" 
        
    found0 = match? required_files[0], 'data_a.rb'    
    assert found0, "Should require root files such as 'data_a.rb' first"     
  end  

  
end

