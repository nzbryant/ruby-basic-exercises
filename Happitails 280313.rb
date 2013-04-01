		
class HappitailsApp

	  # We call the run method to start the application
  def run
    puts # Add a line of white space before the heading
    puts "Welcome to the Rental App!"
    puts
 
    # Now run the method that shows the user the list
    # of actions by number and then reacts to their selection.
    select_main_options
  end

	class Client 
		def initialize (name, age, gender, num_kids, num_pets)
			@name = name
			@age = age
			@gender = gender
			@num_kids = num_kids
			@num_pets = num_pets
		end
		attr_accessor :name, :age, :gender, :num_kids, :num_pets
	end
	 

	class Animal 
		def initialize (name, breed, age, gender, fav_toy, adopted)
			@name = name
			@age = age
			@gender = gender
			@fav_toy = fav_toy
			@adopted = adopted
		end
		attr_accessor :name, :age, :gender, :fav_toy ,:adopted
	end

	def select_main_options
		puts "Please select an option by number:"
		puts "1. List available animals to adopt"
		puts "2. Give up animal for adoption"
		puts "3. List the animals in the shelter"
		puts "4. List the clients"

		case gets.chomp.downcase
		when '1'
			list_adoptable_animals
		when '2'
			add_animal
		when '3'
			list_animals 
		when '4'
			list_clients
		else
      		puts
      		puts "I'm sorry, I didn't understand your input."
    		puts
    		select_main_options
    	end
    end
end
r = HappitailsApp.new
r.run