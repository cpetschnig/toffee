#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), "..", "..", "lib"))

require 'toffee'

Toffee.configure :stdout

('x'.d * 3.d).d

