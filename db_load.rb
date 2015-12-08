require 'db_connection'

class DbLoad

  def initialize
    @db = DBConnection.new('sales')
  end
  
end