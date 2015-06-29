template_letter = File.read "form_letter.html"
require "csv"
require 'sunlight/congress'
require 'erb'



Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

	
	def clean_zipcode(zipcode)
		zipcode.to_s.rjust(5,"0")[0..4]
	end



	def clean_homephone(homephone)
		homephone.gsub!(/\D/, '')
		if homephone.length == 10
			homephone = homephone[0..2] + "-" + homephone[3..5] + "-" + homephone[6..9]
		elsif homephone.length == 11 && homephone[0] == 10
			homephone = homephone[1..10]
		else
			homephone = '000-000-0000'
		end
		
	end
		

	def legislators_by_zipcode(zipcode)
		legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
		
		# legislator_names = legislators.collect do |legislator|
		# 	"#{legislator.first_name} #{legislator.last_name}"
		# end

		# legislator_names.join(", ")

	end

	def save_thank_you_letters(id, form_letter)
		Dir.mkdir("output") unless Dir.exists? "output"

		filename = "output/thanks_#{id}.html"

		File.open(filename, 'w') do |file|
			file.puts form_letter
		end

	end


puts "EventManager Initialized."

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
	id = row[0]
	name = row[:first_name]
	# phone_number = row[:homephone]

	zipcode = clean_zipcode(row[:zipcode])
	phone_number = clean_homephone(row[5])
	legislators = legislators_by_zipcode(zipcode)

	form_letter = erb_template.result(binding)

	save_thank_you_letters(id, form_letter)

	puts form_letter
	# puts phone_number
	
	# puts "#{name} #{phone_number} #{zipcode} legislators"
end

