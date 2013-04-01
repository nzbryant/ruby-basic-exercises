# Get info
puts "How large is your class?"
cs = gets.chomp.to_i

puts "...and the group size?"
gs = gets.chomp.to_i


# Calcs
remainder = cs.%(gs)
puts remainder

if remainder > 0
	number_of_groups = (cs / gs + 1)
	else
	number_of_groups = cs / gs
end	



# Class list
students = ["Sam", "Toby","Rod","George","Kim","Pedro","Juan","Rob","Soner"]
students.shuffle

# Make groups
	# Initialise vars	
	i = 1
	students_remaining = cs

	# Loop
	while i <= number_of_groups do
		puts "Group " + i.to_s + ":"
		list = students.pop([gs, students_remaining].min)
		puts list
		puts ""
		students_remaining = [cs - (gs * i), 0].max
		i = i + 1
	end	

