require 'require-dsl'

module Require
  
  class << self
    attr_accessor :base_path
    attr_accessor :tracing
    attr_accessor :verbose
  end

  def self.recursive(*names, options, &block)
    options = {} if !options     
    options[:recursive] = true
    names.each{|name| folder(name, options) }
  end
  
  def self.folders(*names, options)
    options = {} if !options 
    required_files = []
    names.each do |path| 
      options[:root] = path if is_root?(path, options) 
      required_files << folder(path, options)
    end
    required_files.flatten
  end

  def self.enter(name, options = {}, &block)
    options[:recursive] = true
    file  folder(name, options)
    yield File.dirname(file)    
  end


  def self.folder(name, options = {})
    recursive = options[:recursive]
    folder_list = options[:folders]
    file_pattern =  recursive ? "#{name}/**/*.rb" : "#{name}/*.rb" 
  
    base_dir = File.dirname(__FILE__)
  
    curr_base_path = options[:base_path] || base_path || base_dir
  
    # puts "base_path: #{curr_base_path}, base_dir:#{base_dir}, :base_path #{base_path}"

    path = File.join(curr_base_path, file_pattern)
    required_files = []

    puts_trace "folder:: name: #{name}", options    

    if !options[:root_files] || options[:root_files] == :before
      required_files << require_root_files(name, folder_list, path, options)
      # options[:root] = false
      required_files << require_folder_list(name, folder_list, options)    
    else
      required_files << require_folder_list(name, folder_list, options)          
      required_files << require_root_files(name, folder_list, path, options)
      # options[:root] = false      
    end
    required_files.flatten
  end    

protected
  def self.puts_trace(txt, options)
    puts txt if tracing?(options)    
  end

  def self.tracing?(options)
    tracing == :on || options[:tracing] == :on
  end

  def self.is_root?(path, options)
    root = options[:root]
    root == nil || (root && path.size < root.size)
  end

  def self.require_root_files(name, folder_list, path, options)
    puts_trace "require_root_files:: name: #{name}, folders: #{folder_list.inspect}, path: #{path}", options    
    required_files = []
    i_am_root = options[:root] == name
    if options[:ignore_root_files] && i_am_root
      options.delete :ignore_root_files                        
    else
      includes_rexp = options[:include]
      excludes_rexp = options[:exclude]      
            
      Dir.glob(path).each {|f| 
        next if excludes_rexp &&  match(f, excludes_rexp)
        if !includes_rexp || match(f, includes_rexp)
          puts_trace "require: #{f}", options
          required_files << do_require(f) 
        end
      }
    end    
    
    required_files.flatten
  end

  def self.require_folder_list(name, folder_list, options)
    puts_trace "require_folder_list:: name: #{name}, folders: #{folder_list.inspect}", options    
    required_files = []
    if folder_list
      # options.delete :ignore_root_files            
      options.delete :folders
      
      folder_list.each do |folder|
        sub_folder = File.join(name, folder)
        required_files << folders(sub_folder, options) 
      end
    end
    required_files.flatten
  end

  def self.do_require(name)
    require name 
    list_name name
  end

  def self.list_name(name)    
    if base_path && !(verbose == :on)
      name.gsub(/#{Regexp.escape(base_path)}/, '')
    else
      name
    end
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