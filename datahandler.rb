require 'csv'
require 'time'
require 'rubygems'
require 'fastercsv'
require 'amazon.rb'
require 'linkedinapi.rb'
require 'socialmentionapi.rb'
require 'googlesearchapi.rb'
require 'stackoverflowapi.rb'
require 'ohlohapi.rb'
require 'indeed.rb'


class Datahandler
	def initialize()

		# Adoption Weight
		@adoption_jobs_weight = 66
		@adoption_people_weight = 34

		# Knowledge Weight
		@knowledge_books_weight = 50
		@knowledge_learningmaterial_weight = 33
		@knowledge_questions_weight = 17

		# Sentiment Weight
		@sentiment_weight = 10

		# Evolution Weight
		@age_weight =  66
		@latest_commits = 34

		# Newsworthiness Weight
		@newsworthiness_weight = 100

		@categories = ['pl','wf','cms']

		@metrics_headers = ["date", "technology", "category", "parent", "amazon_books", "people_amount", "job_amount", "positive_ratio", "positive_messages", "neutral_messages", "negative_messages", "learning_materials", "answered_percentage", "age", "description", "logo", "latest_commits", "newsworthiness"]
		@aspect_headers = ["date", "technology", "category", "parent", "adoption", "knowledge", "sentiment", "newsworthiness", "evolution", "total"]		
	end

	def fetch_metrics_data()
		history = CSV::Writer.generate(File.open("history_metrics_data.csv", 'a'))
		history << @metrics_headers

		latest = CSV::Writer.generate(File.open("latest_metrics_data.csv", 'w'))
		latest << @metrics_headers

		FasterCSV.foreach('technologies.csv', :headers => true) do |csv_obj|
			row = csv_obj['technology']
			category =  csv_obj['category']
			parent = csv_obj['parent']
			#puts row

			# Amazon API
			amazon = AmazonAPI.new(row)
			book_amount = amazon.get_book_amount()
			puts "#{row} books: #{book_amount}"

			# LinkedIn API
			linkedin = LinkedinAPI.new(row)
			job_amount = linkedin.get_job_amount()
			puts "#{row} job_amount: #{job_amount}"

			# Indeed
			indeed = Indeed.new(row)
			people_amount = indeed.get_resumes()
			puts "#{row} people_amount: #{people_amount}"

			# Socialmention API
			socialmention = SocialmentionAPI.new(row)
			positive_ratio = socialmention.positive_ratio()
			positive_mes = socialmention.get_positive()
			neutral_mes = socialmention.get_neutral()
			negative_mes = socialmention.get_negative()
			puts "#{row} positive_ratio: #{positive_ratio}"

			# Google Search API
			googlesearch = GoogleSearchAPI.new(row, category)
			learning_materials = googlesearch.get_learningmaterial_results()
			newsworthiness = googlesearch.get_newsworthiness_results()
			puts "#{row} learning_materials: #{learning_materials}"

			# Stackoverflow API
			stackoverflow = StackoverflowAPI.new(row)
			answered_percentage = stackoverflow.get_percentage_answered()

			# Ohloh API
			ohloh = OhlohAPI.new(row)
			age = ohloh.get_age()
			desc = ohloh.get_description()
			logo = ohloh.get_logo()
			latest_commits = ohloh.get_latest_commits()
			puts "#{row} age: #{age}"

			# Currrent date
			t = Time.now
			date = "#{t.month}/#{t.year}"

			# Save to CSV
			fields = [date, row, category, parent, book_amount, people_amount, job_amount, positive_ratio, positive_mes, neutral_mes, negative_mes, learning_materials, answered_percentage, age, desc, logo, latest_commits, newsworthiness]
			history << fields
			latest << fields

		end
		puts "--DONE--"
	end

	def rate_metrics_data()
		@categories.each do |category|
			rate_category_data(category)
		end

		#rate_overview_data()
	end

	def rate_category_data(category)
		@category = category
		technologies_amount = 0
		total_people_amount = 0
		total_job_amount = 0

		total_book_amount = 0
		total_learningmaterial_amount = 0
		total_questions_amount = 0

		total_sentiment_amount = 0

		total_age_amount = 0
		total_latest_commits_amount = 0

		total_newsworthiness_amount = 0


		FasterCSV.foreach('latest_metrics_data.csv', :headers => true) do |csv_obj|
			if csv_obj['category'] == @category
				technologies_amount += 1
				total_people_amount += csv_obj['people_amount'].to_i
				total_job_amount += csv_obj['job_amount'].to_i

				total_book_amount += csv_obj['amazon_books'].to_i
				total_learningmaterial_amount += csv_obj['learning_materials'].to_i
				total_questions_amount += csv_obj['answered_percentage'].to_i

				total_sentiment_amount += csv_obj['positive_ratio'].to_i

				total_age_amount += csv_obj['age'].to_i
				total_latest_commits_amount += csv_obj['latest_commits'].to_i

				total_newsworthiness_amount += csv_obj['newsworthiness'].to_i
			end
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

		age_average = total_age_amount / technologies_amount 
		latest_commits_average = total_latest_commits_amount / technologies_amount 

		newsworthiness_average = total_newsworthiness_amount / technologies_amount

		history = CSV::Writer.generate(File.open("history_#{@category}_aspect_data.csv", 'a'))
		history << @aspect_headers #//	
		latest = CSV::Writer.generate(File.open("latest_#{@category}_aspect_data.csv", 'w'))
		latest << @aspect_headers

		FasterCSV.foreach('latest_metrics_data.csv', :headers => true) do |csv_obj|
			if csv_obj['category'] == @category
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

				# Evolution
				age_rating = csv_obj['age'].to_f / age_average * @age_weight
				latest_commits_rating = csv_obj['latest_commits'].to_f / latest_commits_average * @latest_commits
				evolution_rating = age_rating + latest_commits_rating

				# Newsworthiness
				newsworthiness_rating = csv_obj['newsworthiness'].to_f / newsworthiness_average * @newsworthiness_weight

				# Currrent date
				t = Time.now
				date = "#{t.month}/#{t.year}"

				# Total
				total = adoption_rating + knowledge_rating + sentiment_rating + evolution_rating

				# Save to CSV
				fields = [date, csv_obj['technology'], csv_obj['category'], csv_obj['parent'], adoption_rating.to_i, knowledge_rating.to_i, sentiment_rating.to_i, newsworthiness_rating.to_i, evolution_rating.to_i, total.to_i]
				history << fields
				latest << fields
			end
		end	
		puts "--DONE--"	
	end
end


data = Datahandler.new()
#data.fetch_metrics_data()
data.rate_metrics_data()
