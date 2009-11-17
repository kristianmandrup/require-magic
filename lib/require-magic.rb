module Require
  def self.folder(name, options = {})
    includes_rexp = options[:include]
    excludes_rexp = options[:exclude]
    recursive = options[:recursive]
    folder_list = options[:folders]
    file_pattern =  recursive ? "#{name}/**/*.rb" : "#{name}/*.rb" 
    base_path = File.dirname(__FILE__)
    path = File.join(base_path, file_pattern)
    required_files = []
    
    Dir.glob(path).each {|f| 
      next if excludes_rexp &&  match(f, excludes_rexp)
      if !includes_rexp || match(f, includes_rexp)
        required_files << do_require(f) 
      end
    }
    if folder_list
      options.delete(:folders)     
      folder_list.each do |folder|
        sub_folder = File.join(name, folder)
        required_files << folders(sub_folder, options) 
      end
    end
    required_files.flatten
  end

  def self.folders(folder_list, options = {})
    required_files = []
    folder_list.each do |f| 
      required_files << folder(f, options)
    end
    required_files.flatten
  end

protected
  def self.do_require(name)
    require name 
    name
  end

  def self.match(f, rexp)
    if rexp.kind_of? String
      rexp = /#{Regexp.escape(rexp)}/
    end
      
    if rexp.kind_of? Array
      rexp.each{|e| return true if match(f, rexp)}
      false
    elsif rexp.kind_of? Regexp  
      match_res = (f =~ rexp)
      !match_res.nil?
    end
  end

end