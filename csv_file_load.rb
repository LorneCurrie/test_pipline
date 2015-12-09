require 'csv'

class CsvFileLoad

  attr_reader :files_arr

  def initialize (folder_name, header=false)
    @folder_name = folder_name
    @header = header
    @files_arr = get_csv_files
  end

  def read_file(file_name)
    process_file(CSV.parse(clean_file(file_name), {headers: @header, header_converters: :symbol}))
  end

  :private

  def clean_file(file_name)
    File.read("#{@folder_name}/#{file_name}").tr("\r", '')
  end

  def get_csv_files
    return nil unless Dir.exist?(@folder_name)
    temp_arr = Array.new
    files_temp = Dir.entries(@folder_name)
    files_temp.each do |files|
      temp_arr << files if %w(.csv .CSV).include?(File.extname(files))
    end
    temp_arr
  end

  def process_file csv_table
    array_ret = Array.new
    csv_table.each do |row|
      (address_street, suburb) = row[:address].split(',')
      array_ret << {:address => address_street,
      :suburb => suburb,
      :sale_date => row[:sale_date],
      :amount => row[:amount]
      }
    end
    array_ret
  end

end