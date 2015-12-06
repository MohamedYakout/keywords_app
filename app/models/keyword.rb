require 'roo'
require 'net/http'
require 'httpclient'
require 'uri'


class Keyword < ActiveRecord::Base
	has_many :ad_urls, dependent: :destroy

	attr_accessor :html_page

	def self.import(file)
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		(1..spreadsheet.last_row).each do |i|
			row = spreadsheet.row(i)
			row.each do |word|
				keyword = Keyword.find_or_create_by(word: word)
				keyword.delay.search_on_google if self.word
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
		uri = URI.parse( "http://www.google.co.uk/search" )
		params = {'q'=> self.word}

		http = Net::HTTP.new(uri.host, uri.port) 
		request = Net::HTTP::Get.new(uri.path) 
		request.set_form_data( params )

		# instantiate a new Request object
		request = Net::HTTP::Get.new( uri.path+ '?' + request.body ) 

		response = http.request(request)
		self.html_page = response.read_body
		# self.html_page.force_encoding("ISO-8859-1").encode("UTF-8")
		# self.save!
		self.parsing_html
	end

	def parsing_html
		html_doc = Nokogiri::HTML(self.html_page)
		# Num Results
		num_results_ele = html_doc.css("#resultStats")
		binding.pry
		num_results_str = num_results_ele[0].children[0].to_s
		num_results = num_results_str.gsub(/[^\d]/, '').to_i
		self.total_results = num_results
		self.save!
		# Nodes Results
		top_ads_nodes = html_doc.css("#center_col li.ads-ad h3 a")
		right_ads_nodes = html_doc.css("#rhs_block li.ads-ad h3 a")
		non_ads_nodes = html_doc.css("#ires li h3 a")

		top_ads_nodes.each do |node|
			link = node.attributes["href"].value
			if link.match(/http.*/)
				page_url = link.match(/http.*/)[0]
				puts page_url
				ad_url = self.ad_urls.find_or_create_by(link: page_url)
				ad_url.update(position: "top", is_ad: true)
			end
		end

		right_ads_nodes.each do |node|
			link = node.attributes["href"].value
			if link.match(/http.*/)
				page_url = link.match(/http.*/)[0]
				puts page_url
				ad_url = self.ad_urls.find_or_create_by(link: page_url)
				ad_url.update(link: page_url, position: "right", is_ad: true)
			end
		end

		non_ads_nodes.each do |node|
			link = node.attributes["href"].value
			if link.match(/http.*/)
				page_url = link.match(/http.*/)[0]
				puts page_url
				ad_url = self.ad_urls.find_or_create_by(link: page_url)
				ad_url.update(link: page_url, position: "center", is_ad: false)
			end
		end
	end

	# Keyword.search_google("ruby rails")
end
