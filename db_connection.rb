require 'sqlite3'

class DBConnection

  def initialize(db_name)
    @db_name = db_name
  end

  def get_connection
    SQLite3::Database.new @db_name
  end


end