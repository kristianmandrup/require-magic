module Folder
  module MagicList 
    attr_accessor :base_path
    attr_accessor :rel_path
      
    def do_require(*options)     
      rel_path = options.shift if options && !options.empty?
      each do |file|                     
        req_file = self.rel_path ? File.join(self.rel_path, file) : file                
        require req_file
      end 
      self
    end

    def show_require(*options)
      each do |f|                                                      
        if options.include? :relative                                 
          file_path = File.join(rel_path, f)
          path = Require::Directory.relative_path(base_path, file_path)
        end
        path = File.join(base_path, f) if !options.include? :relative
        path
      end  
    end
    
    def except(*reg_exps) 
      duplicate = self.dup.extend(MagicList)  
      duplicate.each do |file|    
        reg_exps.each {|re| duplicate.delete(file) if file.match(re) }         
      end
      duplicate
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
    end   
   
   protected
     def delete_these(objs) 
       reject! do |obj|  
         a = false
         objs.each do |del|         
           a = true if obj.include? del
         end
         a
       end
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
           
  end
end