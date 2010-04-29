require 'pathname'

module Folder
  class Magic
    attr_accessor :current_path
    attr_accessor :dir_stack
    attr_accessor :relative_path
    
    def initialize      
      @dir_stack = []
      @current_path = FileUtils.pwd
      
    end

    def relative_to_me
      @relative_path = me
    end

    def to_s
      "path: #{current_path}, directory stack: #{dir_stack.inspect}"
    end

    def me       
      Pathname.new(current_path).basename.to_s
    end    
    
    def enter(dir)   
      path = FileUtils.pwd
      dir_stack.push path    
      FileUtils.cd dir if !dir.empty?
      @current_path = FileUtils.pwd
      self.relative_to_me
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
      magic_list(list) 
    end

    def require_all(*folders)
      relative = {:relative_to => relative_path || ''}
      relative = folders.pop if folders && !folders.empty? && folders.last.kind_of?(Hash)      

      puts "relative_to: #{relative[:relative_to]}"

      if folders.empty?
        files = all.dup.extend(MagicList)
        files.rel_path = relative[:relative_to]
        return files.do_require        
      end

      puts "iterate"
      folders.each do |folder|   
        enter folder do |f|   
          file = f.all.dup.extend(MagicList)
          require_relative_to = relative ? relative_to(folder, relative) : folder                     
          file.do_require(require_relative_to)
        end
      end
    end

    def require_me(*files)
      file = all(files).dup.extend(MagicList)
      file.do_require(relative_path)     
    end      

    protected            

    def relative_to(folder, relative)
      puts "relative_to: #{relative.inspect}"      
      puts "relative_to: #{relative[:relative_to]}"      
      relative[:relative_to] ? File.join(relative[:relative_to], folder) : folder
    end
    
    def magic_list(list) 
      list.extend(MagicList)  
      list.base_path = dir_stack.first 
      list.rel_path = current_path    
      list.freeze
    end
            
  end
end