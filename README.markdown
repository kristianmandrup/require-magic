# Require-Me ##

Includes a DSL for requiring files and folders and some also some static utility functions which can be used in combination. 
These tools in combination facilitates managing requiring various subfolder structures.
FIXED 

## Require DSL ##
  
The following example code demonstrates how to use the Require DSL

<pre>
require 'require-dsl'  # to include the Require DSL language only

Folder.enter 'mira' do |folder| # enter subfolder 'mira'
  `# from new location, enter a subdir`
  folder.enter 'subdir' do |path|  # mira/subdir      
    folder.all('**/*.rb').except(/sound\/*.rb/).do_require  
  end

  folder.enter 'another/subdir' do |path|               
    folder.all('**/*.rb').do_require # use file blobs here
  end

  folder.enter 'a_subdir' do |path|         
    `# matching and except are to be used as include and exclude filters
    # they each take a list containing regular expressions and strings
    # string arguments are postfixed with .rb internally if not present`  
    folder.all('blip/**/*.rb').matching(/_mixin.rb/, /.*\/power/).except(/sound/, /disco/).do_require

    folder.enter 'sub_a' do |path|         
      folder.enter 'sub_b' do |path| # a_subdir/sub_a/sub_b         
        folder.all('grusch/**/*.rb').do_require
      end

    end
    folder.all.do_require    
  end
end  
</pre>

If no argument, current path is used as initial folder
 
<pre>
require 'require-me' # include both the static require helpers and the DSL require language  
  
Folder.enter do |folder| # use current path as folder
  folder.enter 'game' do |f|
    folder.require_all # require all .rb files within this folder!  

    `# use static require functions`
    Require.base_path path # set base path to use for Require

    `# include .rb files within data1, data2 but not within their subfolders (use recursive instead)`
    Require.folders('data1', 'data2') 
     
    list = path.all('**/*.rb')    
    puts list.matching('sound', 'network').except(/sound/).show_require(:relative)
    list.matching('sound', 'network').except(/sound/).do_require
  end
end  

# Using new 'require_me' method

Folder.require_me 'fixtures/game/game.rb'
Folder.enter 'fixtures/game' do |f|
  f.require_all
  f.require_me 'game.rb'
end
</pre>

## Static helpers ##

Unit tests demonstrations how to use the static helpers (tests currently broken due to missing data files!):

### Setting the base path ##

Setting global base_path
<pre>
Require.base_path = File.dirname(__FILE__)  
</pre>

Set basepath to use within block
<pre>
Require.enter 'sound' do |path|
  Require.folders 'data' # can be used for any number of folders   
  Require.folder 'data2' # for one folder only
end
</pre>

#### Override base_path ##

<pre>
Require.folders 'data', {:base_path => File.dirname(__FILE__) + '/../my/path}
</pre>

Simple usage examples
Require .rb files from a folder
<pre>
Require.folders 'data', 'data2' 
Require.recursive 'data', 'data2' # recursively require all in subtrees
</pre>

### Simple debugging ##

Get list of required files and print them
<pre>
required_files = Require.folder 'data'
puts required_files  
</pre>

### Tracing mode (for debugging) ##

Apply tracing to see output for the process of requiring the files
<pre>  
  Require.tracing = :on # turn on tracing globally
  Require.folder 'data'  
  Require.tracing = :off # turn off tracing globally
</pre>

Alternatively pass tracing as an option 

<pre>
Require.folder 'data', {:tracing => :on}  
</pre>

### Verbose mode (for detailed debugging) ##

Set verbose mode on to see full path of each required file
<pre>                      
  Require.tracing = :on # turn on tracing          
  Require.verbose = :on # turn on verbose globally
  Require.folder 'data'  
  Require.verbose = :off  # turn off verbose globally
</pre>

### Require.recursive ##

Require all files within the top level folder 'data' recursively 
<pre>
required_files = Require.recursive 'data'  
</pre>

Require all files within the top level folders 'data' and 'data2' (non-recursively) 
<pre>
required_files = Require.recursive 'data', 'data2'  
</pre>

Require all files within the top level folders 'data' and 'data2' recursively
<pre> 
required_files = Require.recursive 'data', 'data2'
</pre>

### Require.folders ##

Require files within the top level folders 'data' and 'data2' and also files within the subdirectory 'blip' if it exists 
<pre>
required_files = Require.folders 'data', 'data2', {:folders => 'blip'}  
</pre>

Require files within 'data/blip' and 'data2/blip' only, NOT including the root files
<pre>
required_files = Require.folders 'data', 'data2', {:folders => 'blip', :ignore_root_files => true}  
</pre>

Require files within 'data' and 'data2' first and then AFTER any files within the subdirectory 'blip' (default order)
<pre>
required_files = Require.folders 'data', 'data2', {:folders => 'blip', :root_files => :before}  
</pre>

Require files within 'data/blip' and 'data2/blip' first and then AFTER any files within 'data' and 'data2' folders (the root files)
<pre>
required_files = Require.folders(['data', 'data2'], {:folders => 'blip', :root_files => :after})
</pre>

Require files within 'data' and 'data2' (the root files) first (BEFORE) and then any files within the subdirectories 'blip' and 'blap'
<pre>
required_files = Require.folders(['data', 'data2'], {:folders => ['blip', 'blap'], :root_files => :before})  
</pre>


## Copyright

Copyright (c) 2010 Kristian Mandrup. See LICENSE for details.
