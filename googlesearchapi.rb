require 'rubygems'
require 'json'
require 'variables.rb'
require 'net/https'
require 'uri'
require 'cgi'

class GoogleSearchAPI
	def initialize(tech_name)
		@tech_name = tech_name
		@baseurl =  "www.googleapis.com"
	end

	def get_learningmaterial_results()
		search_query = "allintitle: \"#{@tech_name} tutorial\" OR \"#{@tech_name} guide\" OR \"learning #{@tech_name}\" OR \"getting started #{@tech_name}\""
		requestpath = "/customsearch/v1?key=#{GOOGLESEARCH_APIKEY}&cx=#{GOOGLESEARCH_CX}&q=#{CGI.escape(search_query)}"
		http = Net::HTTP.new(@baseurl, 443)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		response = http.request(Net::HTTP::Get.new(requestpath))
		data = response.body
		result = JSON.parse(data)

		return result["searchInformation"]["totalResults"]
	end

	def get_newsworthiness_results()
		search_query = "\"#{@tech_name} programming\""
		requestpath = "/customsearch/v1?key=#{GOOGLESEARCH_APIKEY}&cx=#{GOOGLESEARCH_CX}&num=1&q=#{CGI.escape(search_query)}&dateRestrict=m1"
		http = Net::HTTP.new(@baseurl, 443)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		response = http.request(Net::HTTP::Get.new(requestpath))
		data = response.body
		result = JSON.parse(data)

		return result["searchInformation"]["totalResults"]
	end

end
