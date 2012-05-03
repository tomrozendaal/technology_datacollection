require 'rubygems'
require 'json'
require 'variables.rb'
require 'net/https'
require 'uri'
require 'cgi'

class GoogleSearchAPI
	def initialize(tech_name)
		@tech_name = tech_name
	end

	def get_search_results()
		search_query = "allintitle: \"#{@tech_name} tutorial\" OR \"#{@tech_name} guide\" OR \"learning #{@tech_name}\" OR \"getting started #{@tech_name}\""
		baseurl =  "www.googleapis.com"
		requestpath = "/customsearch/v1?key=#{GOOGLESEARCH_APIKEY}&cx=#{GOOGLESEARCH_CX}&q=#{CGI.escape(search_query)}"
		http = Net::HTTP.new(baseurl, 443)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		response = http.request(Net::HTTP::Get.new(requestpath))
		data = response.body
		result = JSON.parse(data)

		return result["searchInformation"]["totalResults"]

		# exact results with nokogiri gem (scrape results)
	end

end

test = GoogleSearchAPI.new("PHP")
puts test.get_search_results()
