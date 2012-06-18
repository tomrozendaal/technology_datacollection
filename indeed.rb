require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi'


class Indeed
	def initialize(tech)
		@tech = tech
	end

	def get_resumes()
		url = "http://www.indeed.com/resumes?q=#{CGI.escape(@tech)}&co=US&rb=jtid%3A1288"
		puts url
		
		doc = Nokogiri::HTML(open(url))
		content = ""
		doc.search('div#result_count').each do |link|
			content = link.content
			content.slice! " resumes"
			if content.include?(",")
				content.slice! ","
			end
		end
		resumes = Integer content
		return resumes
	end
		
end


test = Indeed.new("c#")
puts test.get_resumes()