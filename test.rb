require 'csv'

def print_to_csv
	csv_out = CSV::Writer.generate(File.open('new.csv', 'wb'))

	csv_out << ["Kop1", "Kop2"]
	csv_out << ["Waarde1", "Waarde2"]
	csv_out << ["Waarde11", "Waarde22"]

	puts "--CSV Saved--"

end

def read_csv
	CSV.foreach("new.csv") do |row|
		puts row
	end
	puts "--Done--"
end

#print_to_csv
read_csv
