#!/usr/bin/ruby

require 'csv'

$LOAD_PATH << File.dirname(__FILE__)
require 'csv_file_load'
require 'data_queue'
require 'db_load'

queue = DataQueue.new

n = CsvFileLoad.new('.', true)
n.get_csv_files.each do |file|
  queue.set_table(n.read_file(file))
  db = DbLoad.new
  db.process_pipe_line queue.table
  queue.set_table(Array.new)
end



