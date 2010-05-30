require 'folder/magic'
require 'folder/magic_list'

module Folder
  def self.enter(path = '.', &block) 
    m = Magic.new      
    m.enter path    
    m.relative_to_me    
    if block_given? 
      yield m
    end
    m.exit
  end 

  def self.enter_here(file, &block) 
    m = Magic.new      
    path = File.dirname(file)
    m.enter path   
    m.relative_to_me     
    if block_given?
      yield m
    end
    m.exit
  end 

  def self.rel_base(dir, source, &block)  
    enter(relative_path dir, source, &block) 
  end

  # Folder.require_rel 'spec/spec_helper', __FILE__
  # require /spec/spec_helper.rb relative to current file location
  def self.relative_path(req_file, source, base_dir = nil)
    req_file = File.join(base_dir, req_file) if base_dir
    source_dir = File.dirname(source)
    req_dir = req_file.split('/')[0] || req_file 
    # puts "req_dir: #{req_dir}"
    
    req_file = req_file.split('/')[1]  
    folders = source_dir.split req_dir 
         
    folderlist = folders[1] ? folders[1].split('/') : folders[1]
    if folderlist    
      path_nav = folderlist.inject([]){|res, f| res << '..' }.join('/')     
    else
      path_nav = ''
    end
    File.expand_path(source_dir + "#{path_nav}/#{req_file}")  
  end

  # Folder.require_rel 'spec/spec_helper', __FILE__
  # require /spec/spec_helper.rb relative to current file location
  def self.require_rel(req_file, source, base_dir = nil)
    require relative_path(req_file, source, base_dir)
  end

  def self.require_spec(req_file, source)
    require relative_path(req_file, source, 'spec')
  end

  def self.require_test(req_file, source)
    require relative_path(req_file, source, 'test')
  end

  def self.require_all_recursive(*folders)
    if folders.empty?           
      magics = Magic.new.all_recursive
      return magics.dup.extend(MagicList).do_require
    end
    folders.each do |folder|
      enter folder do |f| 
        fs = f.all_recursive
        fs.dup.extend(MagicList).do_require 
      end
    end
  end    

  def self.require_all(*folders)
    if folders.empty?           
      magics = Magic.new.all
      return magics.dup.extend(MagicList).do_require
    end
    folders.each do |folder|
      enter folder do |f| 
        fs = f.all        
        fs.dup.extend(MagicList).do_require 
      end
    end
  end

  def self.require_all_here(file_name) 
    require_all File.dirname(file_name)               
  end

  def self.require_all_recursive_here(file_name) 
    require_all_recursive File.dirname(file_name)               
  end

  def self.show_require_all_recursive(*folders)  
    if folders.empty?      
      magics = Magic.new.all_recursive
      return magics.dup.extend(MagicList).show_require
    end
    folders.each do |folder|
      enter folder do |f| 
        fs = f.all_recursive
        fs.dup.extend(MagicList).show_require 
      end
    end
  end

  def self.show_require_all(*folders)  
    if folders.empty?      
      magics = Magic.new.all
      return magics.dup.extend(MagicList).show_require
    end
    folders.each do |folder|
      enter folder do |f| 
        fs = f.all        
        fs.dup.extend(MagicList).show_require 
      end
    end
  end

  def self.here(file)
    FileUtils.cd File.dirname(file)
    self
  end    

  def self.require_me_recursive(*files) 
    magics = Magic.new.all_recursive(files)    
    return magics.dup.extend(MagicList).do_require     
  end

  def self.require_me(*files) 
    magics = Magic.new.all(files)    
    return magics.dup.extend(MagicList).do_require     
  end      
  

end