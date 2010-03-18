require 'pathname'

module Require
  module Directory
    def self.relative_path(base_path, path)
      path.gsub! /#{Regexp.escape base_path}/ 
      p1 = Pathname.new base_path
      p2 = p1 + path
      p4 = p2.relative_path_from(p1)  # Pathname:lib/ruby/1.8    
    end
  end
end
  