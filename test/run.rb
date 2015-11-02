#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.dirname(File.realpath(__FILE__)) + '/../lib')

require_relative '../lib/lectors_prober'

puts LectorsProber::Prober.new('322402').to_s
