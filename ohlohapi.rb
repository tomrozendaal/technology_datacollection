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
	end

	def get_age()
		if @doc.root.elements["result/project/analysis/min_month]"]
			first_commit = @doc.root.elements["result/project/analysis/min_month]"].text
			date = Time.parse(first_commit)
			current = Time.new
			return current.year - date.year		
		end
	end

	def get_description()
		if @doc.root.elements["result/project/description]"]
			desc = @doc.root.elements["result/project/description]"].text
			return desc
		end
	end

	def get_logo()
		if @doc.root.elements["result/project/medium_logo_url]"]
			logo = @doc.root.elements["result/project/medium_logo_url]"].text
			return logo
		end
	end

	def get_latest_commits()
		uri = URI("http://www.ohloh.net/projects/#{@tech_name}/analyses/latest/activity_facts.xml?api_key=#{OHLOH_APIKEY}")
		xml_data = Net::HTTP.get(uri) 
		doc = REXML::Document.new(xml_data)

		if doc.root.elements["result"]
			length = Integer(doc.root.elements["result"].elements.size)
			return doc.root.elements["result"].elements[length].elements["commits"].text
		end
	end

end
