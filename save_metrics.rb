require 'csv'
require 'time'
require 'amazon.rb'
require 'linkedinapi.rb'
require 'socialmentionapi.rb'
require 'googlesearchapi.rb'
require 'stackoverflowapi.rb'

def save_metrics
	technologies = CSV::Writer.generate(File.open("technologies.csv", 'a'))
	#technologies << ["php"] << ["java"] << ["ruby"] << ["objective-c"] << ["c++"]

	metrics = CSV::Writer.generate(File.open("tech_metrics.csv", 'a'))
	#metrics << ["date", "technology", "amazon_books", "people_amount", "job_amount", "positive_ratio", "learning_materials", "answered_percentage"]
#=begin
	CSV.foreach("technologies.csv") do |row|
		# Amazon API
		amazon = AmazonAPI.new(row)
		book_amount = amazon.get_book_amount()
		puts "#{row} books: #{book_amount}"

		# LinkedIn API
		linkedin = LinkedinAPI.new(row)
		people_amount = linkedin.get_people_amount()
		puts "#{row} people_amount: #{people_amount}"
		job_amount = linkedin.get_job_amount()
		puts "#{row} job_amount: #{job_amount}"

		# Socialmention API
		socialmention = SocialmentionAPI.new(row)
		positive_ratio = socialmention.positive_ratio();
		puts "#{row} positive_ratio: #{positive_ratio}"

		# Google Search API
		googlesearch = GoogleSearchAPI.new(row)
		learning_materials = googlesearch.get_search_results()
		puts "#{row} learning_materials: #{learning_materials}"

		# Stackoverflow API
		stackoverflow = StackoverflowAPI.new(row)
		answered_percentage = stackoverflow.get_percentage_answered()

		# Currrent date
		t = Time.now
		date = "#{t.month}/#{t.year}"

		# Save to CSV
		metrics << [date,row,book_amount, people_amount, job_amount, positive_ratio, learning_materials, answered_percentage]
	end
#=end
	puts "--DONE--"
end


save_metrics