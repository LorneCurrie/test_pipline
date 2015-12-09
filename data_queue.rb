require 'csv'


class DataQueue

  attr_reader :table

  def initialize(array=nil)
    @table = array
  end

  def set_table(data)
    @table = data
  end

end
