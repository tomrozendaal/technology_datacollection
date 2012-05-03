require 'rubygems'
require 'json'
require 'net/http'
require 'cgi'


class SocialmentionAPI
	def initialize(tech_name)
		@tech_name = tech_name
	end

	# positive percentage
	def positive_ratio()
		#beginning_time = Time.now
		#39 sec
		#url = "http://api2.socialmention.com/search?q=#{@tech_name}&f=json&from_ts=86400&sentiment=true&t[]=blogs&t[]=microblogs"

		#from_ts86400 3 seconden minder

		#40 sec
		#url = "http://api2.socialmention.com/search?q=#{@tech_name}&f=json&from_ts=86400&sentiment=true&t[]=microblogs"
		if @tech_name.is_a?(Array)
			keywords = @tech_name.first
		else
			keywords = @tech_name
		end

		url = "http://api2.socialmention.com/search?q=#{CGI.escape(keywords)}&f=json&sentiment=true&src[]=twitter"

		resp = Net::HTTP.get_response(URI.parse(url))
		data = resp.body
		result = JSON.parse(data)

		#puts result["items"][0]["link"]
		#puts result
		positive = 0;
		neutral = 0;
		negative = 0;
		ratio = 0;
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
		#puts url
		#puts "ratio: #{ratio} positive: #{positive} neutral: #{neutral} negative: #{negative}"

		#end_time = Time.now
		#puts "Time elapsed #{(end_time - beginning_time)} seconds"

		return ratio
	end
end

