require 'csv'

class FileLoad

  attr_reader :files_arr

  def initialize (folder_name, header=false)
    @folder_name = folder_name
    @header = header
    @files_arr = get_csv_files
  end

  def read_file(file_name)
    CSV.parse(clean_file(file_name), {headers: @header, header_converters: :symbol})
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

end