#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.dirname(File.realpath(__FILE__)) + '/../lib')

require_relative '../lib/teacher_teller'

puts TeacherTeller::Teller.new('322402').to_s
