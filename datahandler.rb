require 'csv'
require 'time'
require 'rubygems'
require 'fastercsv'
require 'amazon.rb'
require 'linkedinapi.rb'
require 'socialmentionapi.rb'
require 'googlesearchapi.rb'
require 'stackoverflowapi.rb'


class Datahandler
	def initialize()

		# Adoption Weight
		@adoption_jobs_weight = 65
		@adoption_people_weight = 35

		# Knowledge Weight
		@knowledge_books_weight = 50
		@knowledge_learningmaterial_weight = 30
		@knowledge_questions_weight = 20

		# Sentiment Weight
		@sentiment_weight = 10		
	end

	def fetch_metrics_data()
		headers = ["date", "technology", "amazon_books", "people_amount", "job_amount", "positive_ratio", "learning_materials", "answered_percentage"]
		history = CSV::Writer.generate(File.open("history_metrics_data.csv", 'a'))
		#history << headers

		latest = CSV::Writer.generate(File.open("latest_metrics_data.csv", 'w'))
		latest << headers

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
			fields = [date,row,book_amount, people_amount, job_amount, positive_ratio, learning_materials, answered_percentage]
			history << fields
			latest << fields
		end
		puts "--DONE--"
	end

	def rate_metrics_data()
		technologies_amount = 0
		total_people_amount = 0
		total_job_amount = 0

		total_book_amount = 0
		total_learningmaterial_amount = 0
		total_questions_amount = 0

		total_sentiment_amount = 0;


		FasterCSV.foreach('latest_metrics_data.csv', :headers => true) do |csv_obj|
			technologies_amount += 1
			total_people_amount += csv_obj['people_amount'].to_i
			total_job_amount += csv_obj['job_amount'].to_i

			total_book_amount += csv_obj['amazon_books'].to_i
			total_learningmaterial_amount += csv_obj['learning_materials'].to_i
			total_questions_amount += csv_obj['answered_percentage'].to_i

			total_sentiment_amount += csv_obj['positive_ratio'].to_i
		end

		people_average = total_people_amount / technologies_amount 
		job_average = total_job_amount / technologies_amount 

		books_average = total_book_amount / technologies_amount
		learningmaterials_average = total_learningmaterial_amount / technologies_amount
		questions_average = total_questions_amount / technologies_amount

		sentiment_average = total_sentiment_amount / technologies_amount
		if sentiment_average < 0 
			sentiment_average = -sentiment_average
		end

		headers = ["date", "technology", "adoption", "knowledge", "sentiment", "total"]

		history = CSV::Writer.generate(File.open("history_aspect_data.csv", 'a'))
		#history << headers
		latest = CSV::Writer.generate(File.open("latest_aspect_data.csv", 'w'))
		latest << headers

		FasterCSV.foreach('latest_metrics_data.csv', :headers => true) do |csv_obj|
			# Adoption
			people_rating = csv_obj['people_amount'].to_f / people_average * @adoption_people_weight
			jobs_rating = csv_obj['job_amount'].to_f / job_average * @adoption_jobs_weight
			adoption_rating = people_rating + jobs_rating

			# Knowledge
			books_rating = csv_obj['amazon_books'].to_f / books_average * @knowledge_books_weight
			learningmaterial_rating = csv_obj['learning_materials'].to_f / learningmaterials_average * @knowledge_learningmaterial_weight
			questions_rating = csv_obj['answered_percentage'].to_f / questions_average * @knowledge_questions_weight
			knowledge_rating = books_rating + learningmaterial_rating + questions_rating

			# Sentiment
			if sentiment_average == 0
				sentiment_rating = csv_obj['positive_ratio'].to_f * @sentiment_weight
			else
				sentiment_rating = csv_obj['positive_ratio'].to_f / sentiment_average * @sentiment_weight
			end

			# Currrent date
			t = Time.now
			date = "#{t.month}/#{t.year}"

			# Total
			total = adoption_rating + knowledge_rating + sentiment_rating

			# Save to CSV
			fields = [date,csv_obj['technology'],adoption_rating.to_i, knowledge_rating.to_i, sentiment_rating.to_i, total.to_i]
			history << fields
			latest << fields
		end	
		puts "--DONE--"	
	end
end


data = Datahandler.new()
#data.fetch_metrics_data()
data.rate_metrics_data()

