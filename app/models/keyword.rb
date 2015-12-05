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
			row = spreadsheet.row(i)
			row.each do |word|
				keyword = Keyword.find_or_create_by(word: word)
				keyword.delay.search_on_google
			end
		end
	end

	def self.open_spreadsheet(file)
		case File.extname(file.original_filename)
		when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
		else raise "Unknown file type: #{file.original_filename}"
		end
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
		binding.pry
		self.page = response.read_body
		self.page.force_encoding("ISO-8859-1").encode("UTF-8")
		self.save!
		self.parsing_html
	end

	def parsing_html
		html_doc = Nokogiri::HTML(self.page)
		top_ads_nodes = html_doc.css("#center_col li.ads-ad h3 a")
		right_ads_nodes = html_doc.css("#rhs_block li.ads-ad h3 a")
		non_ads_nodes = html_doc.css("#ires li h3 a")

		top_ads_nodes.each do |node|
			link = node.attributes["href"].value
			page_url = link.match(/http.*/)[0]
			puts page_url
			self.ad_urls.create(link: page_url, position: "top", is_ad: true)
		end

		right_ads_nodes.each do |node|
			link = node.attributes["href"].value
			page_url = link.match(/http.*/)[0]
			puts page_url
			self.ad_urls.create(link: page_url, position: "right", is_ad: true)
		end

		non_ads_nodes.each do |node|
			link = node.attributes["href"].value
			page_url = link.match(/http.*/)[0]
			puts page_url
			self.ad_urls.create(link: page_url, position: "center", is_ad: false)
		end
	end

	# Keyword.search_google("ruby rails")
end
