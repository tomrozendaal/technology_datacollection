require 'rubygems'
require 'cgi'
require 'net/http'
require 'rexml/document'
require 'csv'
require 'time'
require 'variables.rb'

class OhlohAPI
	def initialize(tech_name)
		@tech_name = tech_name
		uri = URI("http://www.ohloh.net/p/#{@tech_name}.xml?api_key=#{OHLOH_APIKEY}")
		xml_data = Net::HTTP.get(uri) 
		@doc = REXML::Document.new(xml_data)
		if @tech_name == 'objective-c'
			exit
		end
	end

	def get_first_commit()
		if @doc.root.elements["result/project/licenses/license"] && @doc.root.elements["result/project/analysis/min_month"]
			first_commit = @doc.root.elements["result/project/analysis/min_month]"].text
			date = Time.parse(first_commit)
			return date.year
		end			
	end

	def get_latest_commit()
		if @doc.root.elements["result/project/licenses/license"] && @doc.root.elements["result/project/analysis/min_month"]
			latest_commit = @doc.root.elements["result/project/analysis/max_month]"].text
			date = Time.parse(latest_commit)
			return date.year
		end			
	end
end

test = OhlohAPI.new('java')
puts test.get_first_commit()
puts test.get_latest_commit()