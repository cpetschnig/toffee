#!/usr/bin/env ruby

# Test: don't set any configuration properties, only use defaults

$:.unshift(File.join(File.dirname(__FILE__), "..", "..", "lib"))

require 'toffee'

('x'.d * 3.d).d

