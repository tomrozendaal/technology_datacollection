require 'csv'
require 'time'
require 'amazon.rb'

def save_metrics
	#technologies = CSV::Writer.generate(File.open("technologies.csv", 'a'))
	#technologies << ["php"] << ["java"] << ["ruby"] << ["objective-c"] << ["c++"]

	metrics = CSV::Writer.generate(File.open("tech_metrics.csv", 'a'))
	#metrics << ["date", "technology", "amazon_books"]
#=begin
	CSV.foreach("technologies.csv") do |row|
		puts "#{row}: #{get_book_amount(row)}"

		# Amazon_books
		book_amount = get_book_amount(row)

		# Currrent date
		t = Time.now
		date = "#{t.month}/#{t.year}"

		# Save to CSV
		metrics << [date,row,book_amount]
	end
#=end
	puts "--DONE--"
end

save_metrics