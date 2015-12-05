require 'roo'
require 'net/http'
require 'httpclient'
require 'uri'


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

	def self.search_google(words)
		words.gsub! ' ', '+'
		url = URI.parse("https://www.google.com.eg/?gfe_rd=cr&gws_rd=cr#q=#{words}")
		req = Net::HTTP::Get.new(url.to_s)
		binding.pry
		res = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(req)
		}
		# puts res.body
		res
	end

	def self.https_google_search
		http = HTTPClient.new
		binding.pry
		response = http.get_content("https://www.google.com/")
		response
	end

	def search_on_google
		uri = URI.parse( "http://www.google.de/search" )
		params = {'q'=> self.word}

		http = Net::HTTP.new(uri.host, uri.port) 
		request = Net::HTTP::Get.new(uri.path) 
		request.set_form_data( params )

		# instantiate a new Request object
		request = Net::HTTP::Get.new( uri.path+ '?' + request.body ) 

		response = http.request(request)
		self.page = response.read_body
		self.save!
	end

	# Keyword.search_google("ruby rails")
end
