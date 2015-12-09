require 'db_connection'
require 'date'

class DbLoad

  def initialize
    @db = DBConnection.new('sales.db').get_connection
    @db.results_as_hash = true
  end


  def create_table
    sql = 'DROP TABLE IF EXISTS dvr_sales;
CREATE TABLE dvr_sales(
address TEXT NOT NULL,
suburb TEXT NOT NULL,
sale_date NUMERIC NOT NULL,
amount NUMERIC NOT NULL);
CREATE INDEX idx_address ON properties.dvr_sales (address);
CREATE INDEX idx_suburb ON properties.dvr_sales (suburb);'

    @db.execute(sql)

  end

  def process_pipe_line data
    return nil if data.nil?
    data.each do |row|
      if validate_sale? row
        update_sale_data(row) if should_update?(row, select_sale(row))
      else
        add_row(row)
      end

    end
  end

  def close_connection
    @db.close
  end

  def validate_sale? (row)
    query = @db.prepare('SELECT count(*) as total FROM dvr_sales where address = :address and suburb = :suburb;')
    query.bind_param(:address, row[:address])
    query.bind_param(:suburb, row[:suburb])
    rs = query.execute

    return rs.first["total"] == 0 ? false : true
  end

  def select_sale (row)
    query = @db.prepare('Select * FROM dvr_sales where address = :address and suburb = :suburb;')
    query.bind_param(:address, row[:address])
    query.bind_param(:suburb, row[:suburb])
    query.execute.first
  end

  def update_sale_data(row)
    query = @db.prepare('UPDATE dvr_sales SET sale_date = :sale_date, amount = :amount WHERE address = :address AND suburb = :suburb')
    query.bind_param(:address, row[:address])
    query.bind_param(:suburb, row[:suburb])
    query.bind_param(:sale_date, row[:sale_date])
    query.bind_param(:amount, row[:amount])
    query.execute
  end

  def add_row (row)
    query = @db.prepare('INSERT INTO dvr_sales (address, suburb, sale_date, amount) VALUES (:address, :suburb, :date, :amount);')
    query.bind_param(:address, row[:address])
    query.bind_param(:suburb, row[:suburb])
    query.bind_param(:date, row[:sale_date])
    query.bind_param(:amount, row[:amount])

    query.execute!

  end

  def should_update?(queue_data, db_data)
     Date.strptime(queue_data[:sale_date], '%d/%m/%y') > Date.strptime(db_data['sale_date'], '%d/%m/%y')
  end


end