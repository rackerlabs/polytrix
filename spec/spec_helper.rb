require 'pacto'
require 'pacto/rspec'
$:.unshift File.expand_path('../pacto', File.dirname(__FILE__))
require 'webmock/rspec'
require 'pacto_server'
require 'tempfile'
require 'goliath/test_helper'

PACTO_SERVER = 'http://identity.api.rackspacecloud.dev:9900' unless ENV['NO_PACTO']

SDKs = Dir['sdks/*'].map{|sdk| File.basename sdk}

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.include Goliath::TestHelper

  c.before(:each)  { Pacto.clear! }
  c.after(:each) { auto_teardown }
end

def auto_teardown
  # require 'pry'; binding.pry
end

def validate_challenge sdk, challenge, vars = standard_env_vars
  sdk_dir = "sdks/#{sdk}"
  pending "#{sdk} is not setup" unless File.directory? sdk_dir
  with_api(PactoServer, {
    :log_file => 'pacto.log',
    :config => 'pacto/config/pacto_server.rb',
    :live => true,
    # :generate => true,
    :verbose => true,
    :validate => true,
    :directory => File.join(Dir.pwd, 'pacto', 'contracts')
    }) do
    EM::Synchrony.defer do
      Bundler.with_clean_env do
        Dir.chdir sdk_dir do
          challenge_script = Dir["challenges/#{challenge}.*"].first
          pending "Challenge #{challenge} is not implemented" if challenge_script.nil?
          # Do bootstrap ahead of challenge?
          # `scripts/bootstrap`
          env_file = setup_env_vars vars
          if File.exists? "scripts/wrapper"
            command = ". #{env_file} && scripts/wrapper #{challenge_script}"
          else
            command = ". #{env_file} && ./#{challenge_script}"
          end
          success = system command
          expect(success).to be_true, "#{sdk} failed to successfully execute the #{challenge} challenge"
          yield success
        end
      end
      EM.stop
    end
  end
end

def setup_env_vars vars
  file = Tempfile.new('vars')
  vars.each do |key, value|
    file.write("export #{key}=#{value}\n")
  end
  file.close
  file.path
end

def standard_env_vars
  @standard_env_vars ||= {
    'RAX_USERNAME'   => ENV['RAX_USERNAME'],
    'RAX_API_KEY'    => ENV['RAX_API_KEY'],
    'RAX_REGION'     => 'DFW',
    'RAX_AUTH_URL'   => PACTO_SERVER || 'https://identity.api.rackspacecloud.com'
  }
end
