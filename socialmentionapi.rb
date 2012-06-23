require 'rubygems'
require 'json'
require 'net/http'
require 'cgi'

MAX_ATTEMPTS = 10

class SocialmentionAPI
	def initialize(tech_name)
		@tech_name = tech_name
		@positive = 0
		@neutral = 0
		@negative = 0
	end

	def positive_ratio()
		attempts = 0

		#beginning_time = Time.now

		if @tech_name.is_a?(Array)
			keywords = @tech_name.first
		else
			keywords = @tech_name
		end

		url = "http://api2.socialmention.com/search?q=#{CGI.escape(keywords)}&f=json&sentiment=true&src[]=twitter&src[]=delicious&src[]=stumbleupon&lang=en&from_ts=86400"
		#url = "http://api2.socialmention.com/search?q=#{CGI.escape(keywords)}&f=json&sentiment=true&t[]=microblogs&lang=en"

		begin
			resp = Net::HTTP.get_response(URI.parse(url))
			data = resp.body
			result = JSON.parse(data)
		rescue Exception => ex
			log.error "Error: #{ex}"
			attempts = attempts + 1
			retry if(attempts < MAX_ATTEMPTS)
		end


		positive = 0
		neutral = 0
		negative = 0
		ratio = 0
		result["items"].each do |key|
			if key["sentiment"] == 0
				neutral = neutral + 1
			end
			if key["sentiment"] > 1
				positive = positive + 1
			end
			if key["sentiment"] < 0
				negative = negative + 1
			end
		end


		if positive == 0 || negative == 0
			if positive > 0
				ratio = "#{(positive).round}"
			elsif negative > positive
				ratio =  "-#{(negative).round}"
			elsif negative == positive
				ratio = "0"
			end
		else
			if positive > negative
				ratio = "#{(positive / negative).round}"
			elsif negative > positive
				ratio = "-#{(negative / positive).round}"
			elsif positive == negative
				ratio =  "0"
			end
		end
		@positive = positive
		@neutral = neutral
		@negative = negative
		puts "ratio: #{ratio} positive: #{positive} neutral: #{neutral} negative: #{negative}"

		#end_time = Time.now
		#puts "Time elapsed #{(end_time - beginning_time)} seconds"

		return ratio
	end

	def get_positive()
		return @positive
	end

	def get_negative()
		return @negative
	end

	def get_neutral()
		return @neutral
	end
end


