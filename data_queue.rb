require 'csv'


class DataQueue

  attr_reader :table

  def initialize(csv_data_table=nil)
    @table = csv_date_table
  end

  def set_table(data)
    @data = data
  end

end
