print "age?"
age = gets.chomp.to_i

if age<40
	puts "young and dumb"
elsif age>=40
	puts "wise"
end

print "color?"
color = gets.chomp.to_s
case color
	when "blue"
		puts "alright!"
	when "red"
		puts "aggro man!"
	else puts "weirdo"
end	


	
