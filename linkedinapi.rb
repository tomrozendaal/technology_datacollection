require 'rubygems'
require 'linkedin'
require 'json'
require 'variables.rb'
require 'rexml/document'

class LinkedinAPI
	def initialize(tech_name)
		@tech_name = tech_name
        @client = LinkedIn::Client.new(LINKEDIN_APIKEY, LINKEDIN_SECRETKEY)
		rtoken = @client.request_token.token
		rsecret = @client.request_token.secret

		@client.authorize_from_access("bf64a9c8-57c0-4653-bacd-cdceae1751fc", "61f85c58-5929-42c5-b99b-bace57ccf04d")
    end 

	def get_people_amount()
		json_data = @client.search({:keywords => @tech_name, :facet => "industry,4"}, "people")

		json_object = JSON.parse(json_data)
		return json_object["numResults"]
	end

	def get_job_amount()
		json_data = @client.search({:keywords => @tech_name, :facet => "industry,4"}, "job")

		json_object = JSON.parse(json_data)
		return json_object["numResults"]
	end


end