# -*- coding: utf-8 -*-
require 'ec2_metadata'
require 'hash_key_orderable'

module Ec2Metadata
  module Command
    class << self
      DATA_KEY_ORDER = %w(meta-data user-data)
      # %w(...)の中に改行を入れるとrcovがパスしていることを認識してくれないので、各行毎に%w(..)します
      META_DATA_KEY_ORDER = 
        %w(ami-id ami-launch-index ami-manifest-path) +
        %w(instance-id instance-type instance-action) +
        %w(public-keys/ placement/ security-groups) +
        %w(hostname) +
        %w(public-hostname public-ipv4) +
        %w(local-hostname  local-ipv4) +
        %w(block-device-mapping/) +
        %w(kernel-id) +
        %w(ramdisk-id) +
        %w(reservation-id)

      def show(api_version = 'latest')
        v = (api_version || '').strip
        unless Ec2Metadata.instance.keys.include?(v)
          raise ArgumentError, "API version must be one of #{Ec2Metadata.instance.keys.inspect} but was #{api_version.inspect}"
        end
        show_yaml_path_if_loaded
        data = Ec2Metadata[v].to_hash
        data.extend(HashKeyOrderable)
        data.key_order = DATA_KEY_ORDER
        meta_data = data['meta-data']
        meta_data.extend(HashKeyOrderable)
        meta_data.key_order = META_DATA_KEY_ORDER
        puts YAML.dump(data)
      end

      def show_api_versions
        show_yaml_path_if_loaded
        puts Ec2Metadata.instance.keys
      end

      private
      def show_yaml_path_if_loaded
        if path = Ec2Metadata::Dummy.loaded_yaml_path
          puts "Actually these data is based on a DUMMY yaml file: #{path}"
        end
      end
    
    end
  end
end
