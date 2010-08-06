require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'logger'

describe "Toffee" do

  before :all do
    @log_obj = Logger.new(STDOUT)
  end

  it "configure does some checks on its arguments" do
    # check argument must be given
    lambda {Toffee.configure}.should raise_exception ArgumentError

    # second argument must be a Symbol or Hash
    lambda {Toffee.configure(:foo, Time)}.should raise_exception TypeError
    lambda {Toffee.configure(@log_obj, :error)}.should_not raise_exception
    # will result in logging to :debug
    lambda {Toffee.configure(@log_obj, :a => 1)}.should_not raise_exception

    # try to log to write protected file
    lambda {Toffee.configure('/etc/oh-no-this-must-not-work.log')}.should raise_exception IOError

    # method must be valid
    lambda {Toffee.configure(@log_obj, :foo)}.should raise_exception ArgumentError

    # test for default :debug method
    lambda {Toffee.configure(Time)}.should raise_exception TypeError
  end

  it "writes to STDOUT, when no configuration was made" do
    %x{#{File.join(File.dirname(__FILE__), 'test-apps/all_defaults_app.rb')}}.should == %{"x"\n3\n"xxx"\n}
  end

  it "accepts various configurations for STDOUT" do
    %x{#{File.join(File.dirname(__FILE__), 'test-apps/all_defaults_app.rb')}}.should == %{"x"\n3\n"xxx"\n}
    %x{#{File.join(File.dirname(__FILE__), 'test-apps/STDOUT_app.rb')}}.should == %{"x"\n3\n"xxx"\n}
    %x{#{File.join(File.dirname(__FILE__), 'test-apps/stdout_symbol_app.rb')}}.should == %{"x"\n3\n"xxx"\n}
  end

end
