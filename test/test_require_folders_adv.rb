require 'require-magic'
require "unit_test_require"
 
class TestRequireFoldersAdv < UnitTestRequire

  def test_require_folders_recursive
    options = {:folders => ['blip'], :ignore_root_files => true}
    required_files = Require.folders(@folders, options)
    assert_equal 3, required_files.size, "Should require 3 files" 
  end  

  def test_require_folders_root_folders_before
    options = {:folders => ['blip'], :root_files => :before}
    required_files = Require.folders(@folders, options)
    assert_equal 4, required_files.size, "Should require 4 files" 

    root_first = match?(required_files[0], 'data_a.rb') 
    assert root_first, "First required file should be root file 'data_a.rb'"                  
  end  
  
  def test_require_folders_root_folders_after
    options = {:folders => ['blip'], :root_files => :after}
    required_files = Require.folders(@folders, options)
    assert_equal 4, required_files.size, "Should require 4 files" 

    root_last = match?(required_files[2], 'data_a.rb')        
    assert root_last, "Last required file of 'data' should be root file 'data_a.rb'"
  end

  def test_require_folders_root_folders_before_but_ignore
    options = {:folders => ['blip'], :root_files => :before, :ignore_root_files => true}
    required_files = Require.folders(@folders, options)

    assert_equal 3, required_files.size, "Should require 3 files" 
  end

  def test_require_folders_root_folders_after_but_ignore
    options = {:folders => ['blip'], :root_files => :after, :ignore_root_files => true}
    required_files = Require.folders(@folders, options)
    assert_equal 3, required_files.size, "Should require 3 files" 
  end

  def test_require_folders_recursive_data_root_folders_after
    options = {:folders => ['blip'], :root_files => :after}
    required_files = Require.folders('data', options)
    assert_equal 3, required_files.size, "Should require 3 files" 
    
    root_last = match?(required_files[2], 'data_a.rb')
    
    assert root_last, "Last required file should be root file 'data_a.rb'"     
  end  


end