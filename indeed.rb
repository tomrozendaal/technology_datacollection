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
		
		doc = Nokogiri::HTML(open(url))
		resumes = ""
		doc.search('div#result_count').each do |link|
			resumes = link.content
			if resumes.include?("resumes")
				resumes.slice! " resumes"
			elsif resumes.include?("resume")
				resumes.slice! " resume"
			end
			
			if resumes.include?(",")
				resumes.slice! ","
			end

			if resumes == ""
				resumes = "0"
			end
		end
		return resumes
	end
		
end
