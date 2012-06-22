require 'rubygems'
require 'json'
require 'variables.rb'
require 'net/https'
require 'uri'
require 'cgi'
require 'zlib'
require 'stringio'

class StackoverflowAPI
	def initialize(tech_name)
		@baseurl = "http://api.stackexchange.com/2.0"
		
		case tech_name
		when 'play'
			@tech_name = 'playframework'
		when 'hippo'
			@tech_name = 'hippocms'
		else
			@tech_name = tech_name
		end

		if @tech_name.include? ' '
			@tagged_tech_name = @tech_name.gsub!(' ','-')
		else
			@tagged_tech_name = @tech_name
		end	
	end

	def get_unanswered_questions_amount()
		request_url =  "/questions/unanswered?order=desc&sort=activity&tagged=#{@tagged_tech_name}&site=stackoverflow&filter=!n-9EI7zilb"

		url = URI.parse(@baseurl + request_url)
      	response = Net::HTTP.get_response(url)
      	gz = Zlib::GzipReader.new(StringIO.new(response.body))

		json = JSON.parse(gz.read)
		return json["total"]
	end

	def get_total_questions_amount()
		request_url =  "/questions?order=desc&sort=activity&tagged=#{@tagged_tech_name}&site=stackoverflow&filter=!n-9EI7zilb"

		url = URI.parse(@baseurl + request_url)
      	response = Net::HTTP.get_response(url)
      	gz = Zlib::GzipReader.new(StringIO.new(response.body))

		json = JSON.parse(gz.read)
		return json["total"]
	end

	def get_percentage_answered()
		total_questions = get_total_questions_amount().to_f
		unanswered_questions = get_unanswered_questions_amount().to_f

		if total_questions > 0
			answered_percentage = (total_questions - unanswered_questions) / total_questions * 100
			return answered_percentage.round
		else
			return 0
		end
	end
end


