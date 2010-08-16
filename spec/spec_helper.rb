$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'toffee'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
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
