#!/usr/bin/env ruby

begin
  require 'marketing_api'
rescue LoadError
  require 'rubygems'
  require 'marketing_api'
end