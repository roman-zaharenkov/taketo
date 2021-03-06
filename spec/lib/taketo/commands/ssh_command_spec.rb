require 'spec_helper'
require 'taketo/commands'

include Taketo::Commands

describe "SSH Command" do
  let(:server) do
    stub(:Server, :host => "1.2.3.4",
                  :port => 22,
                  :username => "deployer",
                  :identity_file => "/home/gor/.ssh/qqq")
  end

  subject(:ssh_command) { SSHCommand.new(server) }

  it "composes command based on provided server object" do
    ssh_command.render("foobar").should == %q[ssh -t -p 22 -i /home/gor/.ssh/qqq deployer@1.2.3.4 "foobar"]
  end

  it "ignores absent parts if they are not required" do
    server.stub(:port => nil, :username => nil, :identity_file => nil)
    ssh_command.render("foobar").should == %q[ssh -t 1.2.3.4 "foobar"]
  end
end

