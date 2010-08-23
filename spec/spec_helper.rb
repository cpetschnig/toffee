$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'toffee'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end


TEMP_LOG_FILE = '/tmp/toffee_spec.log'


def rand_str(base_length = 5, var_length = 5)
  result = ''
  (base_length + rand(var_length)).times{ result << (65 + rand(26)).chr }
  result
end


class SpecLogger
  attr_reader :output
  def test_log(output)
    @output ||= []
    @output << output
  end
  def clear_log
    @output = []
  end
end


class ArbitraryObjectWithPutsMethod
  attr_reader :output
  def puts(output)
    @output ||= []
    @output << output
  end
end


class ArbitraryObjectWithDebugMethod
  attr_reader :output
  def debug(output)
    @output ||= []
    @output << output
  end
end


class ArbitraryObjectWithAsdfMethod
  attr_reader :output
  def asdf(output)
    @output ||= []
    @output << output
  end
end


