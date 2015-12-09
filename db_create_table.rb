#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)
require 'db_load'

begin
  db = DbLoad.new
  puts "#{db.inspect}"
  db.create_table
rescue SQLite3::Exception => e
  puts "Exception::"
  puts "#{e}"
ensure
  #db.close_connection
end


