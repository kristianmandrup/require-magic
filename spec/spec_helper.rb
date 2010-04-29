$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))
# require 'require-dsl'
require 'load-me'
require 'require-me'
require 'rspec'
require 'rspec/autorun'