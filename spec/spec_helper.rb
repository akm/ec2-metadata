$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ec2_metadata'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

REVISIONS = [
  '1.0',
  '2007-01-19',
  '2007-03-01',
  '2007-08-29',
  '2007-10-10',
  '2007-12-15',
  '2008-02-01',
  '2008-09-01',
  '2009-04-04',
  'latest'
  ]

DATA_TYPES = %w(dynamic user-data meta-data)

ATTR_NAMES = %w(ami-id ami-launch-index ami-manifest-path) +
  # block-device-mapping/
  %w(hostname instance-action instance-id instance-type kernel-id) +
  %w(local-hostname local-ipv4) +
  # placement/
  %w(public-hostname public-ipv4) +
  # public-keys/
  %w(ramdisk-id reservation-id security-groups)
