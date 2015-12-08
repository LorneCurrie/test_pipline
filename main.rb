#!/usr/bin/ruby

require 'csv'

$LOAD_PATH << File.dirname(__FILE__)
require 'file_load'
require 'data_queue'

queue1 = DataQueue.new

n = FileLoad.new('.', true)
file = n.get_csv_files.first
queue1.set_table(n.read_file(file))


