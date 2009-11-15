module Require
  def self.folder(name, options)
    includes_rexp = options[:include]
    excludes_rexp = options[:exclude]
    recursive = options[:recursive]
    folder_list = options[:folders]
    
    file_pattern =  recursive ? "#{name}/**/*.rb" : "#{name}/*.rb"    
    Dir.glob(File.join(File.dirname(__FILE__), file_pattern)).each {|f| 
      next if excludes &&  match(f, excludes_rexp)
      require f if !match || match(f, includes_rexp)
    }
    folders(folder_list, options) if folder_list
  end

  def self.folders(folder_list, options)
    folder_list.each(|f| folder(f, options))
  end

protected
  def match(f, rexp)
    if rexp.kind_of? Array
      rexp.each{|e| return true if match(f, rexp)}
      false
    elsif rexp.kind_of? RegExp  
      f =~ rexp
    end
  end

end