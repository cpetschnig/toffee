require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'logger'

describe "Toffee" do

  before :all do
    @log_obj = Logger.new(STDOUT)
    @spec_logger = SpecLogger.new
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

  it "works with any object that implements a 'puts' method" do

  end

  it "writes to a file when configured with a string value" do
    
  end

  it "writes to an object with an arbitrary method name" do

  end

  it "writes to any object with a 'debug' method" do

  end

  it "truncates a file to zero length with the 'clear' method" do

  end

  it "writes timestamps when configured to do so" do
    # turn off timestamping by passing nil
    Toffee.configure @spec_logger, :test_log, :timestamp => nil
    'foo'.d
    @spec_logger.output.last.should == '"foo"'

    # turn on timestamp and use the default format
    Toffee.configure :timestamp => true
    'foo'.d
    time_result = Time.utc(*@spec_logger.output.last[0..(Toffee::DEFAULT_TIMESTAMP_FORMAT.size)].gsub(/[: ]/, '-').split('-'))
    # there should not be more than half a second in between
    (Time.new - time_result).should < 0.5


    # turn off timestamping passing false
    Toffee.configure :timestamp => false
    'foo'.d
    @spec_logger.output.last.should == '"foo"'


    # turn on timestamp and use the default format
    Toffee.configure :timestamp => '[%Y|%m|%d|%H|%M|%S] '
    'foo'.d
    time_result = Time.utc(*@spec_logger.output.last[1..20].split('|'))
    # there should not be more than half a second in between
    (Time.new - time_result).should < 0.5

    Toffee.configure :timestamp => false
    @spec_logger.clear_log
  end

  it "can compute multiple calls to 'configure'" do

  end

  it "gives correct file position and call stack output" do

  end

end
