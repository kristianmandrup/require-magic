require 'rake'
require 'fileutils'
require 'util/util'

module Folder

  def self.enter(path = '.', &block) 
    m = Magic.new      
    m.enter path    
    if block_given?
      yield m
    end
    m.exit
  end 

  def self.require_all(*folders)
    return Magic.new.all.dup.extend(MagicList).do_require if folders.empty?
    folders.each do |folder|
      enter folder do |f|
        f.all.dup.extend(MagicList).do_require
      end
    end
  end



  
  module MagicList 
    attr_accessor :base_path
    attr_accessor :rel_path
        
    def do_require
      each do |file|
        require file
      end 
      self
    end

    def show_require(*options)
      each do |f|                                                      
        if options.include? :relative                                 
          file_path = File.join(rel_path, f)
          path = Require::Dir.relative_path(base_path, file_path)
        end
        path = File.join(base_path, f) if !options.include? :relative
        path
      end  
    end

     
    def delete_these(objs) 
      reject! do |obj|  
        a = false
        objs.each do |del|         
          a = true if obj.include? del
        end
        a
      end
    end
    
    def except(*reg_exps) 
      duplicate = self.dup.extend(MagicList)  
      duplicate.each do |file|    
        reg_exps.each {|re| duplicate.delete(file) if file.match(re) }         
      end
      duplicate
    end        

    def postfix_rb(str)
      str << '.rb' if !str.include? '.rb'            
    end            

    def fix(str)   
      postfix_rb(str) 
      str = Regexp.escape(str)
      str.gsub! '\*', '[a-zA-Z0-9\s_-]*'
      str.gsub! '/', '\/'
      str
    end
    
    def matching(*reg_exps) 
      duplicate = self.dup.extend(MagicList)  
      keep_list = []
      duplicate.each do |file| 
        reg_exps.each do |re|
          re = fix(re) if re.kind_of? String
          keep_list << file if file.match(re)
        end
      end                              
      reject_list = (duplicate - keep_list).flatten
      duplicate.delete_these(reject_list)
      duplicate
    end    
  end

  class Magic
    attr_accessor :current_path
    attr_accessor :dir_stack
    
    def initialize      
      @dir_stack = []
      @current_path = FileUtils.pwd
    end
    
    def enter(dir)   
      path = FileUtils.pwd
      dir_stack.push path    
      FileUtils.cd dir if !dir.empty?
      @current_path = FileUtils.pwd
      if block_given?
        yield self                    
        exit              
      end      
      self
    end

    def exit
      current_path = dir_stack.last
      old_dir = dir_stack.last 
      dir_stack.pop 
      FileUtils.cd old_dir if old_dir               
    end


    def all(*globs)
      globs = '**/*.rb' if globs.empty?      
      list = FileList.new(globs)
      list.extend(MagicList)  
      list.base_path = dir_stack.first 
      list.rel_path = current_path    
      list.freeze
    end

    def require_all(*folders)
      return all.dup.extend(MagicList).do_require if folders.empty?
      folders.each do |folder|
        enter folder do |f|
          f.all.dup.extend(MagicList).do_require
        end
      end
    end
        
  end
end  
              
    
    

    