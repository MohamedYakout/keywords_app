require 'roo'

class Keyword < ActiveRecord::Base
	has_many :ad_urls

	def self.import(file)
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		(1..spreadsheet.last_row).each do |i|
			puts spreadsheet.row(i)
		end
	end

	def self.open_spreadsheet(file)
		case File.extname(file.original_filename)
		when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
		else raise "Unknown file type: #{file.original_filename}"
		end
	end
end
