require File.expand_path('../../spec_helper', __FILE__)
require 'taketo/dsl'

describe "Taketo DSL" do
  it "should parse config and instantiate objects" do
    factory = Taketo::ConstructsFactory.new
    config = Taketo::DSL.new(factory).configure do
      project :slots do
        environment :staging do
          server :staging do
            host "127.0.0.2"
            user "deployer"
            location "/var/app"
          end
        end

        environment :production do
          {
            :s1 => "127.0.0.3",
            :s2 => "127.0.0.4",
          }.each do |server_name, host_name|
            server server_name do
              host host_name
              location "/var/app"
            end
          end
        end
      end
    end

    config.projects.length.should == 1
    project = config.projects[:slots]
    project.name.should == :slots

    project.environments.length.should == 2
    staging = project.environments[:staging]
    
    staging.servers.length.should == 1
    staging_server = staging.servers[:staging]
    staging_server.host.should == "127.0.0.2"
    staging_server.username.should == "deployer"
    staging_server.default_location.should == "/var/app"

    production = project.environments[:production]
    production.servers.length.should == 2
  end
end
