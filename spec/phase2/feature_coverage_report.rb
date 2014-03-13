require 'spec_helper'
require 'yaml'

yaml_files = Dir['reports/api_coverage*.yaml']
coverage = {}
yaml_files.each do |file|
  coverage.merge! YAML::load(File.read(file))
end

data = YAML::load(File.read('pacto/rackspace_uri_map.yaml'))
data['services'].each do |service_group_name, service_group|
  describe service_group_name do
    services = service_group['services'] || []
    services.each do |service_name, service|
      describe service_name do
        SDKs.each do |sdk|
          it sdk, sdk.to_sym do
            sdk_coverage = coverage.select{|k,v| k =~ /#{sdk}$/ }
            # Pass or pending, no "fail" state right now
            pending unless sdk_coverage.values.flatten.include? service_name
          end
        end
      end
    end
  end
end
