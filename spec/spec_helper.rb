$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ec2_metadata'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
