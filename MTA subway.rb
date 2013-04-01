# MTA subway exercise

n = ["ts", "34th", "28th", "23rd", "us", "8th"]
l = ["8th", "6th", "us", "3rd", "1st"]
six = ["gc", "33rd", "28th", "23rd", "us", "astor"]

puts "Hello. Please see the lines and stops available:"
puts "N line:" + nline.to_s
puts "L line:" + lline.to_s
puts "6 line:" + sixline.to_s

puts "What line will you take? (N) N line, (L) L line, or (6) 6 Line"
	online = gets.chomp.downcase
	if online = 6 then online == "six"
puts "What stop will you get on at?"
	onstop = gets.chomp.downcase
puts "What line will you get off from? (N) N line, (L) L line, or (6) 6 Line"
	offline = gets.chomp.downcase
puts "What stop will you get off at?"
	offstop = gets.chomp.downcase

# Exit on same line?
if online == offline then sameline 

puts sameline

# Calc stops on same line
#	if sameline then
#		distance = (online.index("onstop") - offline.index("offstop"))	
#	end