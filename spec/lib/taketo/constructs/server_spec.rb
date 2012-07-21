require File.expand_path('../../../../spec_helper', __FILE__)
require 'taketo/constructs/server'

include Taketo

describe "Server" do
  let(:environment) { environment = stub(:Environment, :name => :the_environment) }
  let(:server) { Taketo::Constructs::Server.new(:foo) }

  it "should have name" do
    server.name.should == :foo
  end

  it "should set host" do
    server.host = "foo"
    server.host.should == "foo"
  end

  it "should set port" do
    server.port = "foo"
    server.port.should == "foo"
  end

  it "should set username" do
    server.username = "foo"
    server.username.should == "foo"
  end

  it "should set default_location" do
    server.default_location = "foo"
    server.default_location.should == "foo"
  end

  describe "#environment=" do
    it "should set environment" do
      server.environment = environment
      server.environment.should == environment
    end

    it "should set RAILS_ENV environment variable" do
      server.environment_variables.should == {}
      server.environment = environment
      server.environment_variables[:RAILS_ENV].should == environment.name.to_s
    end
  end

  it "should set environment variables" do
    server.env :FOO => "bar"
    server.env :BAR => "baz"
    server.environment_variables.should include(:FOO => "bar", :BAR => "baz")
  end

  context "Commands" do
    let(:command) { mock(:Command, :name => :foo).as_null_object }

    describe "#append_command" do
      it "should add a command to servers's commands collection" do
        server.append_command(command)
        server.commands.should include(command)
      end
    end

    describe "#find_command" do
      it "should find command by name" do
        server.commands.should_receive(:find_by_name).with(:foo).and_return(:bar)
        server.find_command(:foo).should == :bar
      end
    end
  end
end

