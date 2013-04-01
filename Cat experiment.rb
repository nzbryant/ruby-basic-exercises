module Saleable
	attr_accessor :price
	class_attr_accessor :tax_rate
	
end

module Quarantined
		def price
				puts "This animal is Quarantined"
		end
	end				

class Pet
	include Saleable	
	include Quarantined

	attr_accessor :name

	def initialize (options = {})
		@name = options[:name] if options.has_key? :name
		
	end

	def speak
		puts "baaa"
	end	

	def bites(pet)
			puts "ow #{pet}. #{name}!"
	end
			
	def to_s
		puts """
		Hi my name is #{name} and Im your new pet.
		"""		
	end
end

class Cat < Pet
	def speak
		puts "meow"
 	end
end

class Dog < Pet
end

