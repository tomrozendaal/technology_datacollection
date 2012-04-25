require 'rubygems'
require 'cgi'
require 'time'
require 'hmac'
require 'hmac-sha2'
require 'base64'
require 'rexml/document'
require 'csv'
require 'variables.rb'

def get_book_amount(tech_name)

	params = {
	  'Operation' => 'ItemSearch',
	  'Service' => 'AWSECommerceService',
	  'AssociateTag' => 'tomrozendaal-20',
	  'SearchIndex' => 'Books',
	  'BrowseNode' => '5', # Computers & Technology / Computers & Internet
	  'Title' => tech_name,
	  'AWSAccessKeyId' => ACCESS_IDENTIFIER,
	  'Timestamp' => Time.now.iso8601,
	}

	canonical_querystring = params.sort.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&')
	string_to_sign = "GET
ecs.amazonaws.com
/onca/xml
#{canonical_querystring}"
	                              
	hmac = HMAC::SHA256.new(SECRET_IDENTIFIER)
	hmac.update(string_to_sign)
	signature = Base64.encode64(hmac.digest).chomp # chomp is important!  the base64 encoded version will have a newline at the end

	params['Signature'] = signature
	querystring = params.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&') # order doesn't matter for the actual request

	xml_data = `curl -X"GET" "#{AMAZON_ENDPOINT}?#{querystring}" -A"simple ruby aws sdb wrapper"`
	doc = REXML::Document.new(xml_data)
	book_amount = doc.root.elements["Items/TotalResults]"].text


	# Save to CSV
	csv_out = CSV::Writer.generate(File.open('new.csv', 'a'))

	t = Time.now
	date = "#{t.month}/#{t.year}"
	csv_out << [date, tech_name, book_amount]

	puts "--CSV Saved--"
end

get_book_amount(ARGV[0])