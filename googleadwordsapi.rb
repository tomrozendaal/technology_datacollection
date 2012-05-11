require 'rubygems'

gem 'google-adwords-api'
require 'adwords_api'

adwords = AdwordsApi::Api.new({
  :authentication => {
     :method => 'ClientLogin',
     :developer_token => 'NpCd1JMpodtF9e-O5r7BAA',
     :user_agent => 'Ruby Sample',
     :password => 'wachtwoord',
     :email => 'info@tomrozendaal.nl',
     :client_customer_id => '153-470-4728'
  },
  :service => {
   :environment => 'PRODUCTION'
  }
})

keyword = "php programming"
targeting_srv = adwords.service( :TargetingIdeaService, :v201109 )
  selector = {
    :idea_type => 'KEYWORD',
    :request_type => 'STATS',
    :requested_attribute_types => [ 'GLOBAL_MONTHLY_SEARCHES' ],
    :search_parameters => [
      {
        :xsi_type => 'RelatedToKeywordSearchParameter',
        :keywords => [ { :text => keyword, :match_type => 'EXACT' } ]
      }
    ],
    :paging => {
      :start_index => 0,
      :number_results => 100
    }    
  }

monthly_searches = nil
    page = targeting_srv.get(selector)
    if page and page[:entries] then
      first_entry= page[:entries].first()
      if !first_entry.nil? && !first_entry[:data].nil? then
        first_data_entry = first_entry[:data].first()
        monthly_searches = first_data_entry[:value][:value] if !first_data_entry.nil?
      end
    end
    if !monthly_searches.nil? then
      puts "There are \"#{monthly_searches}\" searches for \"#{keyword}\"."
    else
      puts "Unable to retrieve monthly searches for \"#{keyword}\"."     
    end

puts adwords