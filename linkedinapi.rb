require 'rubygems'
require 'linkedin'
require 'variables.rb'

client = LinkedIn::Client.new(LINKEDIN_APIKEY, LINKEDIN_SECRETKEY)
rtoken = client.request_token.token
rsecret = client.request_token.secret

# to test from your desktop, open the following url in your browser
# and record the pin it gives you
#puts client.request_token.authorize_url
#=> "https://api.linkedin.com/uas/oauth/authorize?oauth_token=<generated_token>"

#print "Enter pin: "
#pin = gets.strip

# then fetch your access keys
#puts client.authorize_from_request(rtoken, rsecret, pin)
#=> ["OU812", "8675309"] # <= save these for future requests

# or authorize from previously fetched access keys
client.authorize_from_access("bf64a9c8-57c0-4653-bacd-cdceae1751fc", "61f85c58-5929-42c5-b99b-bace57ccf04d")

# industry code => 4
puts client.search({"keywords" => "php", "industry-code" => "4"})