require 'csv'
require 'time'

def print_to_csv
	#wb override csv
	#a+ append to csv
	#date,technology,amazonbooks
	csv_out = CSV::Writer.generate(File.open('new.csv', 'a'))
	#csv_out << ["date", "technology", "amazonbooks"]

	t = Time.now
	date = "#{t.day}/#{t.month}/#{t.year}"

	csv_out << [date, "PHP", "1337"]

	puts "--CSV Saved--"

end

def read_csv
	CSV.foreach("new.csv") do |row|
		puts row
	end
	puts "--Done--"
end

print_to_csv
#read_csv
