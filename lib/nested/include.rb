required_files = Require.rfolder('nested', {:exclude => 'include', :tracing => :on})
puts required_files.inspect