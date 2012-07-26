require File.expand_path('../../../../spec_helper', __FILE__)
require 'taketo/commands/ssh_command'

include Taketo::Commands

describe "SSH Command" do
  let(:environment) { stub(:Environment, :name => :staging) }
  let(:server) do
    stub(:Server, :name => :s1,
                  :host => "1.2.3.4", 
                  :port => 22,
                  :username => "deployer", 
                  :default_location => "/var/app",
                  :identity_file => "/home/gor/.ssh/qqq",
                  :environment => environment,
                  :environment_variables => {})
  end
  let(:command) { mock(:Command, :render => "the_command") }

  let(:ssh_command) { SSHCommand.new(server) }

  it "should compose command based on provided server object" do
    ssh_command.render("foobar").should == %q[ssh -t -p 22 -i /home/gor/.ssh/qqq deployer@1.2.3.4 "foobar"]
  end

  it "should ignore absent parts" do
    server.stub(:port => nil)
    server.stub(:username => nil)
    server.stub(:identity_file => nil)
    ssh_command.render("foobar").should == %q[ssh -t 1.2.3.4 "foobar"]
  end

  it "should require host" do
    server.stub(:host => nil)
    expect { ssh_command.render("bash") }.to raise_error ArgumentError, /host/
  end
end

