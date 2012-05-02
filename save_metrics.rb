require 'csv'
require 'time'
require 'amazon.rb'
require 'linkedinapi.rb'
require 'socialmentionapi.rb'

def save_metrics
	technologies = CSV::Writer.generate(File.open("technologies.csv", 'a'))
	#technologies << ["php"] << ["java"] << ["ruby"] << ["objective-c"] << ["c++"]

	metrics = CSV::Writer.generate(File.open("tech_metrics.csv", 'a'))
	#metrics << ["date", "technology", "amazon_books", "people_amount", "job_amount", "positive_ratio"]
#=begin
	CSV.foreach("technologies.csv") do |row|
		# Amazon API
		amazon = AmazonAPI.new(row)
		book_amount = amazon.get_book_amount()
		puts "#{row} books: #{book_amount}"

		# LinkedIn API
		linkedin = LinkedinAPI.new(row)
		people_amount = linkedin.get_people_amount()
		job_amount = linkedin.get_job_amount()

		# Socialmention API
		socialmention = SocialmentionAPI.new(row)
		positive_ratio = socialmention.positive_ratio();

		# Currrent date
		t = Time.now
		date = "#{t.month}/#{t.year}"

		# Save to CSV
		metrics << [date,row,book_amount, people_amount, job_amount, positive_ratio]
	end
#=end
	puts "--DONE--"
end


save_metrics