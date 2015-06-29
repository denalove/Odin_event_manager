template_letter = File.read "form_letter.html"
require "csv"
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

	
	def clean_zipcode(zipcode)
		# if zipcode.nil?
		# 	zipcode = "00000"
		# elsif zipcode.length < 5
		# 	zipcode = zipcode.rjust 5, "0"
		# elsif zipcode.length > 5
		# 	zipcode = zipcode(0..4)
		# else
		# 	zipcode 
		zipcode.to_s.rjust(5,"0")[0..4]
	end



	def clean_homephone(homephone)
		# phone_number = homephone
		unless homephone == false
			# homephone.delete! '()-'
			homephone
		else
			"no homephone"
		end
	end
		

		#if less then 10 digits, its a bad number
		#if 10 digits, its good
		# if 11 digits and first number is 1, trim the one
		#if 11 digits and the first number is not 1, then bad number
		#if more then 11 digits, its a bad number



		# homephone.gsub("-", "")
		# homephone.gsub(" ", "")


		# if phone.length == 11
		# 	phone = phone(1..11)
		# else
		# 	phone
		# end
		
	

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
	phone_number = row[:homephone]

	zipcode = clean_zipcode(row[:zipcode])
	phone_number = clean_homephone(row[:HomePhone])
	legislators = legislators_by_zipcode(zipcode)

	form_letter = erb_template.result(binding)

	save_thank_you_letters(id, form_letter)

	# puts form_letter
	# puts phone_number
	
	puts "#{name} #{phone_number} #{zipcode} legislators}"
end
	
	# lines = File.readlines "event_attendees.csv"
	# lines.each do |line|
 #  		columns = line.split(",")
 #  		phone_number = columns[5]
 #  		puts phone_number
	# end
	
	
	
# end
# contents.each do |row|
#   name = row[:first_name]

#   zipcode = clean_zipcode(row[:zipcode])


#   legislators = legislators_by_zipcode(zipcode).join(", ")

#   personal_letter = template_letter.gsub('FIRST_NAME',name)
#   personal_letter.gsub!('LEGISLATORS',legislators)

#   puts personal_letter
