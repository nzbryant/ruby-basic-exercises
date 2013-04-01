require 'rainbow' # pretty coloury shite to make us look cool
 
# We be rentals!
 
# THE PURPOSE OF THIS IS TO ILLUSTRATE HOW OOP USES CLASSES
# AND PASSES MESSAGES BETWEEN THEM, AND SOME BASIC CONSIDERATIONS
# WITH REGARD TO INTERFACE DESIGN, VALIDATING INPUT, ETC.
 
# THIS IS NOT THE BEST WAY TO DESIGN THIS SORT OF APP!
# THERE ARE LOTS OF IMPORTANT THINGS THAT ARE SIMPLY BEYOND THE
# SCOPE OF WEEK 1. YOU DIDN'T WANT ME TO MAKE THIS EVEN MORE
# COMPLICATED, DID YOU?
 
# This is the main class that controls the input/output and
# creates and deletes the various Building, Apartment, and Person objects
class RentalApp
  # TEMPORARY FOR DEBUGGING PURPOSES; REMOVE IN PRODUCTION APP
  # attr_accessor :buildings, :persons 
 
  # We create a buildings hash to hold the buildings
  # with the address of the building as the key.
  # Also, we create an array of persons.
  # Why an array and not a has? Well, unless we want to assign
  # each person a unique ID and work with that, what would we
  # use as the key?
  # Finally, we set an odd_row flag to allow us to set table rows
  # to alternate colors (more on this below).
  def initialize
    @buildings = {}
    @persons = []
    @odd_row = true
  end
 
  # We call the run method to start the application
  def run
    puts # Add a line of white space before the heading
 
    # Output the welcome message.
    # puts_heading is a method we created to format our
    # headings for us using rainbow (see below).
    puts_heading "Welcome to the Rental App!"
 
    # Now run the method that shows the user the list
    # of actions by number and then reacts to their selection.
    # See below for the details of this method.
    select_main_options
  end
 
  # Everything below this keyword is inaccessible from outside
  # the RentalApp class. In other words, the only method visible
  # to users of the RentalApp is the run method. Cool, eh?
  private
 
  # Utility methods: these methods encapsulate useful functionality
  # to help us to format strings, output messages in color, etc.
 
  # Given a string and a length, pad that string with white space
  # out to the given length and return the padded string.
  # For example, pad("xxx",7) will return "xxx    ".
  # We need this to create tables in the terminal, as you'll see.
  def pad(str, len)
    out = str.to_s           # copy the string to our output variable
                             # and make sure it's a string
    while out.length < len   # while the string length is less than len,
                             # loop and add a space
      out += " "             # add the space to the end of the string
    end
    out                      # return the padded string
  end
 
  # We can pass this a string message and it will output it in white text
  # against a big, colorful box. The default is a green background. If we
  # pass true for is_error, the background will be red.
  # Note that this method depends entirely on side effects - we don't care
  # what it returns
  def puts_message(message, is_error = false)
    # We're going to put blank lines above and below to create the box,
    # so we need to know how long the message text is.
    len = message.length
    padding = "  " # We add a space to either side of the message,
                   # so we start with 2 spaces
                   
    len.times { padding += " " } # Loop len times adding spaces
                                 # to the box padding line
                                 
    # set the background color depending on error or info
    color = if is_error then :red else :green end 
    puts # add a blank line above the box
    
    # add the blank colored top line of the box
    puts padding.color(255,255,255).background(color) 
    
    # add the message line
    puts " #{message} ".color(255,255,255).background(color)
    
    # add the blank colored bottom line of the box
    puts padding.color(255,255,255).background(color)
    puts # add a blank line below the box
  end
 
  # We use this to put the heading lines
  # (e.g., "Welcome to the Rental App!"")
  # By using a method for this, we can avoid repeating
  # the .color part over and over again
  # Also, if we decide to change the heading color or
  # other formatting, we can do it all in one place!
  # Nice, eh?
  def puts_heading(heading)
    puts # add a blank line above for spacing
    puts heading.color(0,0,153) # blue
  end
 
  # Same as above, but for the "request" lines that ask the user
  # to take an action, e.g., "Please select an option below!""
  def puts_request(request)
    puts
    puts request.color(204,0,0) # red
  end
 
  # Same as above, but for the list of options from which
  # the user may choose, e.g., buildings, persons, etc.
  def puts_option(option)
    puts option.color(0,51,0) # dark green
  end
 
  # Creates a "separator" line (a horizontal rule) to separate
  # option sections or table headings from table rows.
  # Defaults to 50 hyphens, but the user can set the width
  # of the separator with the :width option, and change
  # the separator itself with the :separator option.
  def puts_separator(options = {})
    sep = options[:separator] || "-" # set the default separator to -
    len = options[:width] || 50      # set the default width to 50 chars
    str = ""                         # initialize the string
    len.times { str += sep}          # loop len times adding the separator
                                     # to the string
    puts str.color(153,153,153)      # puts the separator in a nice gray
  end
 
  # Same as other methods above, but puts a table heading
  def puts_table_heading(th)
    puts
    puts th.color(51,0,51) # purple
  end
 
  # Same as above, but puts a table row. ALSO! Fancy schmancy:
  # alternates black and gray for the rows!
  def puts_table_row(tr)
    if @odd_row
      puts tr.color(0,0,0) # if the odd_row is true, use black
    else
      puts tr.color(51,51,51) # if the odd_row is false, use gray
    end
 
    # Now we invert the value of odd_row
    # (false -> true or true -> false)
    # so that the next row will be the other color
    @odd_row = if @odd_row then false else true end
      
    # Note: we could also have done: @odd_row = (not @odd_row)
    # Which do you like better?
  end
 
  # OK, we're done with the utility methods, now let's get
  # into the meat of the program!
 
  # This is the main method that provides the options menu
  # and lets the user select what action to take.
  # We come back to this over and over again until the user
  # selects q to quit, then we exit the method and the app
  # with a goodbye message.
  def select_main_options
    len = 63 # this is the length of the longest line below,
             # for sizing the separators
 
    # Read the utilities section above to see what these methods do.
    # They are mostly for formatting the output.
    puts_request "Please select an option by number:"
    puts_separator :width => len
    puts_option " 1: Add a new building"
    puts_option " 2: View all buildings"
    puts_option " 3: Remove a building (and all apartments/tenants in it)"
    puts_separator :width => len
    puts_option " 4: Add an apartment to a building"
    puts_option " 5: View all the apartments in a building"
    puts_option " 6: Remove an apartment (and all tenants in it) " +
      "from a building"
    puts_separator :width => len
    puts_option " 7: Add a new person"
    puts_option " 8: View all persons"
    puts_option " 9: Remove a person"
    puts_separator :width => len
    puts_option "10: Add a tenant to an apartment"
    puts_option "11: Remove a tenant from an apartment"
    puts_separator :width => len
    puts_option " q: Quit the rental application"
    puts
 
    # When the user makes her selection, we use a case/when to direct
    # the execution to the appropriate action.
    # Note that we use methods for each action. These methods are private,
    # that is, they can only be called from inside this class.
    # That means that all the user can do is run the program. All input
    # must be via the interface, where we can control what happens.
    # Heh, heh.
    case gets.chomp.downcase # downcase so the user can quit with q or Q
    when '1'
      add_building
    when '2'
      show_buildings
    when '3'
      remove_building
    when '4'
      add_apartment
    when '5'
      show_apartments
    when '6'
      remove_apartment
    when '7'
      add_person
    when '8'
      show_persons
    when '9'
      remove_person
    when '10'
      add_new_tenant
    when '11'
      remove_old_tenant
    when 'debug'
      # Output everything for debugging
      show_buildings
      @buildings.each do |k,v|
        unless v.apartments.empty?
          list_apartments_by_building(v)
        end
      end
      show_persons
    when 'q'
      # Say goodbye and quit
      puts_message "Thank you for using the Rental Application."
      # Now let's return from this method immediately,
      # i.e., do not continue to the recursive call below.
      return "See you next time..." 
    else
      puts_message "I'm sorry, I didn't understand your input.", true
    end
 
    # If the user didn't choose q/Q above, thus calling the return,
    # then we just call this method again from within itself.
    # This is called "recursion" and is a very useful way to loop
    # through a program. Later, we'll talk about potential problems
    # with recursion, but for this program, it's fine.
    select_main_options
  end
 
  # ==========================
  # BUILDINGS
  # ==========================
 
  # This is the first of the possible user actions. It prints out
  # a table of all the buildings in the system.
  # Pay close attention to the table formatting.
  def show_buildings
    
    # We don't want to output an empty table (how unprofessional),
    # so we'll check to see if the buildings hash is empty,
    # and if it is, we'll output a message instead. Cool, eh?
    if @buildings.empty?
      puts_message "You haven't added any buildings yet. Enter 1 to add one."
    else
      puts_heading "BUILDINGS" # set our headline
 
      # Get the length of the longest address and the longest style.
      # We need this to get the width of our table right.
      # The 3 is for a bit of padding between columns.
      len_address = @buildings.values.map {|b| b.address.length}.max + 3
      
      # set default size if no styles
      len_style = [@buildings.values.map {|b| b.style.length}.max, 5].max + 3
      
 
      # So now lets create our table heading line by padding out
      # the following columns. Note that the rows below use
      # the same amount of padding. See how useful our "pad"
      # utility method is? (See above to find the method.)
      th = pad("Address", len_address) +
        pad("Style", len_style) +
        pad("Door?", 8) +
        pad("Lift?", 8) +
        pad("Apts", 8)
 
      # Now we output the table heading with a separator
      # using the utility functions.
      # Note that the 24 is the 8 + 8 + 8 from above.
      # Is there a better way to do this?
      puts_table_heading(th)
      puts_separator :width => (len_address + len_style + 24),
        :separator => "="
 
      # OK, with the table heading and a separator established,
      # let's loop through the buildings and create our rows of data.
      @buildings.each do |key, building|
        # convert the boolean to a Yes or nothing
        door = if building.has_doorman then 'Yes' else '' end
          
        # convert the boolean to a Yes or nothing
        lift = if building.has_elevator then 'Yes' else '' end
 
        # Now create the row of data. Note that we don't need to pad
        # the final column - all we'd be adding is empty spaces
        # at the end of the row.
        num_apts = building.apartments.length
        tr = pad(building.address, len_address) +
          pad(building.style, len_style) +
          pad(door, 8) +
          pad(lift, 8) +
          if num_apts > 0 then num_apts.to_s else "" end
 
        # Now use our utility method to output that row.
        # See the puts_table_row method above to see
        # how we alternate gray/black for the row colors
        # to make reading individual rows easier.
        puts_table_row(tr)
      end
    end
    puts
  end
 
  # This method interacts with the user to create a new building,
  # putting information to the terminal and then collecting
  # attributes from the user.
  def add_building
    puts_heading "Add a new building..." # our heading
 
    # Ask for the address.
    puts_request "Please enter the building's address:" 
    address = gets.chomp # get the address from the user
 
    puts_request "Optionally, enter the building's style (e.g., Gothic):"
    style = gets.chomp
 
    puts_request "Enter y if the building has a doorman:"
    has_doorman = gets.chomp
 
    puts_request "Enter y if the building has a lift:"
    has_elevator = gets.chomp
 
    # OK, we got the address, style, doorman, and lift info,
    # now let's create our options hash so we can create
    # the building with Building.new
    options = {}
    options[:style] = style
    options[:has_doorman] = has_doorman.downcase == 'y'
    options[:has_elevator] = has_elevator.downcase == 'y'
 
    # We'll go ahead and create a new building, assigning it
    # to a temporary variable
    building = Building.new(address, options)
 
    # Now let's see if we were successful!
    if (building)
      # Success! We have a new building object. Add it to
      # the buildings hash using the address as the key,
      # then output a success message.
      @buildings[address] = building
      puts_message "Added a new building at #{building.address}."
    else
      # Failure! Oh, no! Output a failure message. Note the "true"
      # at the end which sets the background color to red
      # (see puts_message above).
      puts_message "Failed to add your building. Sorry!", true
    end
 
    # Well, that was easy. No?
    puts
  end
 
  # This is the method to remove a building from the application.
  # It's a bit trickier, but you can follow it, trust me.
  # Let's dive in...
  def remove_building
    # Gotta have buildings to remove them! Let's exit if there are
    # no buildings yet.
    if @buildings.empty?
      puts_message "You must add buildings before you can delete them!"
      return "Try again?"
    end
    # We want to list the buildings so the user can choose one to remove.
    # To make it easy, we'll number them. And what better way to number
    # a list of objects than by putting them in an array!
    # Then our array index is our number (after we add 1 to it).
    # So we create an array of the buildings hash KEYS.
    # See how we use them below.
    keys = @buildings.keys
 
    # Put the heading and ask the user to choose a building by number.
    puts_heading "Remove a building from the listings!"
    puts_request "Please choose the building by number:"
 
    # Loop through the array of keys, outputting the various
    # building options from which the user will choose.
    keys.each_index do |i|
      # i is the index of the key in the array (starting at 0).
      # key is the key for that building in the buildings hash
      # (the address of the building).
      key = keys[i]
      
      # Now we put the index (+1 to make it 1-based) and
      # the address of the building (the key).
      # Run this to see how nicely it works.
      puts_option "  #{i + 1}: #{key}"
    end
    puts
 
    # Now the user chooses an option by entering a number. This is
    # the array index of the key for that building in the buildings hash,
    # plus 1. So we subtract 1 to get the correct key.
    idx = gets.chomp.to_i - 1
 
    # Let's test to make sure we have an index within
    # the keys array range. If not, we'll output an error message.
    if idx >= 0 and idx < keys.length
      # We have an index in the array. Let's make sure they
      # really want to delete this building...
      puts_message "Are you sure? Enter X to remove, " +
        "anything else to cancel.", true
 
      # OK, let's get their input and check if it's X. Why x?
      # Why not y? Any ideas?
      if gets.chomp.downcase == 'x'
        # They are sure! OK, let's remove the building.
        key = keys[idx]  # get the key from the keys array
        building = @buildings[key]  # use the key to get the building
 
        # Now let's loop through the building's apartments
        # to remove all the tenants. If we don't do this,
        # we'll have tenants in our tenants array who appear to be 
        # in a building for which we no longer provide rentals.
        # Oops! That would not be good.
        building.apartments.each do |apartment|
          apartment.remove_all_tenants
        end
 
        # Now we'll drop the building from the hash so
        # it can be garbage collected.
        @buildings.delete key
 
        # Let's show the buildings table again so
        # the users can see that the building is gone.
        show_buildings
 
        # And print a success method. Not as hard as it looked, is it?
        puts_message "The building at #{key} has been deleted."
      else
        # Whoops! They changed their mind. Maybe they selected
        # the wrong building? So show the list again to reassure them,
        # then output a "canceled" message in a pleasant green.
        show_buildings
        puts_message "Removal of the building at #{key} has been canceled."
      end
    else
      # Bad input! Output an error message!
      puts_message "I'm sorry, I didn't understand your input.", true
    end
  end
 
  # ==========================
  # APARTMENTS
  # ==========================
 
  # Buildings done, let's move on to apartments. This method shows the list
  # of apartments for a selected building. So first they have to choose
  # the building, then we show the apartments.
  def show_apartments
    # We want them to choose a building, so again we need
    # an array of keys to provide a convenient numbering system.
    keys = @buildings.reject { |k,v| v.apartments.empty? }.keys
 
    # Hey! Let's check to make sure that buildings have been added!
    # Kind of pointless to output an empty table for them to choose from.
    if keys.empty?
      # Warn them that they have to enter buildings first.
      if @buildings.empty?
        puts_message "You haven't added any buildings yet. " +
          "Enter 1 to add one."
      else
        puts_message "You haven't added any apartments yet. " +
          "Enter 4 to add one."
      end
    else
      # OK, there are buildings available. So print the heading
      # and ask them to choose one.
      puts_heading "View apartments by building..."
      puts_request "Please choose a building by number:"
 
      # Now we loop through the building keys as we did in the
      # remove_building method above.
      # (See how many things are repeated? Maybe this should be
      # in its own method?). Then we output one building per line,
      # with the index (+1) as the number to choose.
      keys.each_index do |i|
        key = keys[i]
        puts_option "  #{i + 1}: #{key}"
      end
      puts # get some separation here -- white space is good!
 
      # OK, let's get their choice, convert it to an integer,
      # and subtract 1 to get the correct index
      idx = gets.chomp.to_i - 1
 
      # Now let's make sure this is a possible index in the keys array!
      if idx >= 0 and idx < keys.length
        # It is, so we can go ahead and add an apartment
        # use the index to get the correct hash key
        key = keys[idx]
        
        # now use the key to get the correct building
        building =  @buildings[key]
 
        # Let's handle the case where there are no apartments yet
        # differently, so we can avoid an empty table.
        if building.apartments.empty?
          # No apartments yet: show a message.
          puts_message "There are no apartments in this building yet."
        else
          # Heh, let's use a separate method to list the apartments
          # once we have the building. This way we can reuse it below.
          list_apartments_by_building(building)
        end
      else
        # Print an error message if the number
        # was outside our building array!
        puts_message "Sorry, I didn't recognize that number. ", true
      end
    end
    puts
  end
 
  # We'll put this method right here so
  # it's close to where we use it (above)
  def list_apartments_by_building(building)
    # We have apartments!
    # Show the heading with the building address in parentheses
    # just to make it easier for the user.
    puts_heading "APARTMENTS (#{building.address})"
 
    # We won't bother resizing columns, we'll assume that
    # the apt number is short. Create and put the table heading
    # and separator. To differentiate tables from options lists,
    # let's use = as a separator.
    th = "No          Size    Rent    Furn?   Beds    Loos    Tenants"
    puts_table_heading(th)
    puts_separator :width => th.length, :separator => "="
 
    # Now let's loop through apartments and create rows for our table.
    # And let's sort them.
    keys = building.apartments.keys.sort
    keys.each do |key|
      apartment = building.apartments[key]
 
      # Convert the is_furnished boolean to Yes or nothing
      furn = if apartment.is_furnished then "Yes" else "" end
      # Let's convert 0 beds to "Studio"
      beds = if apartment.num_beds == 0
        "Studio"
      else
        apartment.num_beds
      end
 
      # Make the table row for this apartment
      tr = pad(apartment.apt_num, 12) +
        pad(apartment.size.to_s + "m2", 8) +
        pad("L" + apartment.rent.to_s, 8) +
        pad(furn, 8) +
        pad(beds, 8) +
        pad(apartment.num_loos.to_s, 8) +
        apartment.tenants.length.to_s
 
      # Now use our puts_table_row utility method to put
      # the table row to standard output
      puts_table_row(tr)
    end
    puts
  end
 
  # Now we want to add apartments. We have to start by choosing a building.
  # Note that this will work similarly to the above method. There might
  # be a DRYer way to do this. Can you think of one?
  def add_apartment
    keys = @buildings.keys # get the keys array just as above
 
    # Check to make sure we have buildings to which to add an apartment!
    if keys.empty?
      # No buildings yet? Output an error message.
      puts_message "You haven't added any buildings yet. " +
        "Please add a building first."
    else
      # OK, we have a building. Let's output the heading and
      # ask them to choose by number.
      puts_heading "Add an apartment to a building..."
      puts_request "Please choose a building by number:"
      puts
 
      # Now let's output the building choices, but first, let's figure out
      # which building has the longest address (remember, the keys to
      # the buildings hash ARE the addresses of the buildings).
      # Then we'll set our separator width to that length.
      # It just looks nicer.
      width = @buildings.keys.map {|k| k.length}.max
      puts_separator :width => width
 
      # Now we output the building choices, one per line, just as before.
      # Loop through the keys array, passing in the index. Then use
      # the index to get the key. Finally, put the index (+1 for 1-based)
      # and the key (which is the address of the building, right?)
      # to standard output.
      keys.each_index do |i|
        key = keys[i]
        puts "#{i + 1}: #{key}"
      end
 
      # Now let's get the user's choice, convert to an integer,
      # and subract 1 to get the actual index in the keys array.
      idx = gets.chomp.to_i - 1
 
      # Check to see if they picked a number within the array!
      if idx >= 0 and idx < keys.length
        # Yes! They chose an actual building. Smart user! Let's get
        # the key (address) for that building, and the building, too.
        key = keys[idx]
        building =  @buildings[key]
 
        # OK, we're going to create an apartment, right? So we need
        # a blank options hash to work with.
        options = {}
 
        # Let's start getting the apartment data. We'll get the length
        # of our request line and then create a separator the same length.
        req = "Please enter the apartment number:"
        puts_request req
        puts_separator :width => req.length
 
        # Now get the apartment number from the user.
        apt_num = gets.chomp
 
        # Let's get the rest of the data, converting it as necessary.
        puts_option "Optionally, enter the apartment size in square meters:"
        options[:size] = gets.chomp.to_i # convert to integer
 
        puts_option "Optionally, enter the monthly rent in pounds:"
        options[:rent] = gets.chomp.to_i # convert to integer
 
        puts_option "Enter y if the apartment is furnished:"
        # Convert y or Y to true, else false.
        options[:is_furnished] = gets.chomp.downcase == 'y' 
 
        puts_option "Optionally, enter the number of bedrooms:"
        options[:num_beds] = gets.chomp.to_i # convert to integer
 
        puts_option "Optionally, enter the number of loos:"
        options[:num_loos] = gets.chomp.to_i # convert to integer
 
        # We need to associate the apartment with a building!
        options[:building] = building 
 
        # Let's create the new apartment and assign it to a temp variable.
        apartment = Apartment.new(apt_num, options)
 
        # Did it work?
        if apartment
          # Yes! Add the apartment to the building's apartment hash.
          building.apartments[apt_num] = apartment
 
          # Now show the apartments list and send
          # a success message to the user.
          list_apartments_by_building(building)
          puts_message "Added apartment #{apt_num} to #{building.address}."
        else
          # Well, crap. Something went wrong. Alert the user.
          puts_message "Failed to add the new apartment! Sorry. ", true
        end
      else
        # Choose a number between one and ten. Eleven!
        # OK, maybe our user isn't so smart after all.
        puts_message "I'm sorry. I didn't get the building. " +
          "Please try again.", true
      end
    end
    puts
  end
 
  # To remove an apartment, we're going to have to ask the user
  # to choose the building first, so we'll provide a numbered list
  # of buildings. Then we'll have to provide a numbered list
  # of apartments in the building they chose. Then finally,
  # we'll have to remove that apartment (and it's tenants).
  # This is the most difficult method. If you understand this one,
  # you've got this programming stuff down!
  def remove_apartment
    # We're going to list the buildings so the user can choose one,
    # so again we start by getting an array of the buildings hash's keys.
    keys = @buildings.keys
 
    # No buildings? No apartments to delete...
    if keys.empty?
      # Let's remind the user that he has to have *buildings*
      # before he can have apartments to delete.
      puts_message "You haven't added any buildings yet. " +
        "Please add a building first."
    else
      # OK, we have buildings. Put the headline.
      puts_heading "Remove an apartment from the listings!"
 
      # Now put the request to choose a building, plus a separator
      # of the same length.
      req = "Please choose the building by number:"
      puts_request req
      puts_separator :width => req.length
 
      # Now put the buildings, one per line. Are you beginning
      # to see the benefit of making the address of the building
      # the hash key? We don't even have to access the buildings hash
      # here to print indexes and addresses.
      # As above, we loop through the array of hash keys (addresses),
      # passing in the array index. Then we use the index to get
      # the key (address). Then we print the index
      # (plus one to make the list one-based) and the address (the key).
      # Nice!
      keys.each_index do |i|
        key = keys[i]
        # puts_option is a utility method we defined above.
        puts_option "  #{i + 1}: #{key}" 
      end
 
      # Let's get the number from the user, convert it from string
      # to integer, and subtract one to undo our plus one above
      # (so we have the right array index)
      idx = gets.chomp.to_i - 1
 
      # Let's check if the user picked a number from the one's we gave her.
      if idx >= 0 and idx < keys.length
        # She did! Let's get the key and then the building,
        # then create an array of keys from the building's apartments hash
        # so we can list the apartments and make it easy for the user
        # to choose them by number.
        key = keys[idx]
        building =  @buildings[key]
        apt_keys = building.apartments.keys
 
        # Now we'll list the apartments with index numbers.
        # Start with the prompt to the user to choose an apartment
        # by number (1, 2, 3, etc.), then add a separator line
        # of the same length.
        req = "Please choose the apartment by number:"
        puts_request req
        puts_separator :width => req.length
 
        # Now we'll loop through the apartment keys array, passing in
        # the array index. In the loop, we'll print out the options
        # using the index (plus one to make it one-based) and the key,
        # which we've wisely chosen to be the apt_num! Damn, we're good!
        apt_keys.each_index do |i|
          # Note that we don't necessarily have to use a temp variable
          # (key = apt_keys[i]), we can just as easily do it
          # right in the interpolated string!
          puts_option "#{i + 1}: #{apt_keys[i]}"
        end
 
        # Get the user's choice, convert it to an integer, and
        # subtract 1 to get back to the right index in the apt_keys array.
        idx = gets.chomp.to_i - 1
 
        # Hey, did our user actually choose a working number? Let's check
        # if the idx we got is actually in the apt_keys array.
        # What a concept! We can DO that? Yes! We can do anything.
        # We're programmers, baby.
        if idx >= 0 and idx < apt_keys.length
          # Yes! They chose an actual apartment! Let's delete the thing!
          # But first, maybe we should double check? Yeah, we'd better or
          # we'll have pissed off customers, blaming us
          # for their own mistakes.
          puts_message "Are you sure? Enter X to remove, " +
            "anything else to cancel.", true
 
          # Why X? Why not Y? You tell me...
          if gets.chomp.downcase == 'x'
            # Get the key for this apartment in the apartments hash.
            key = apt_keys[idx]
            
            # Now get the apartment with it.
            apartment = building.apartments[key]
 
            # Hey! Weren't we smart to add a remove_all_tenants method
            # to the Apartment class? Look how easy we made it. And we
            # can do many things in the transaction and make
            # sure that they are all done, or none, but not only some.
            apartment.remove_all_tenants
 
            # Now that we've removed the apartment from the tenants'
            # list of apartments for all tenants, we just need to drop
            # the apartment from the building's apartments hash.
            building.apartments.delete key
 
            # And, finally, show the list and let the user know
            # that we removed the apartment.
            list_apartments_by_building(building)
            puts_message "Apartment #{key} has been removed " +
              "from the building at #{building.address}."
          else
            # They bailed! Whew! Good thing we let them, huh?
            list_apartments_by_building(building)
            puts_message "Removal of apartment #{key} " +
              "at #{building.address} has been canceled."
          end
        end
      end
    end
    puts
  end
 
  # ==========================
  # PERSONS
  # ==========================
 
  def show_persons
    # Let's check to make sure there are persons entered so we don't
    # output an empty table. How much more professional to provide
    # a prompt instead!
    if @persons.empty?
      # Lucky thing we checked, huh?
      puts_message "You have not entered any persons yet."
    else
      # OK, we gots persons. Let's output the heading and
      # a separator (we'll use the default).
      puts_heading "PERSONS"
      puts_separator
 
      # Let's get the list of persons and sort them by name
      # The sort method takes a block that passes in two values
      # at a time to be compared. Then we can indicate
      # how to compare them. Here we compare the name attribute
      # of each person, so they will be sorted by name.
      persons = @persons.sort { |a,b| a.name <=> b.name }
 
      # Now let's loop through the persons array and list the persons.
      # There isn't much data, so we'll make it human readable.
      for person in persons
        # We're going to output different text based on
        # how many rentals they have.
        apts = person.apartments.length
 
        # Let's build the string we're going to output as the line.
        line =  person.name
        
        # Only add the age if we know it.
        line += ", #{person.age}," if person.age
 
        # OK, let's handle three different case: no apartment, one,
        # or more than one.
        case apts
          when 0
            line += " has no apartments currently"
          when 1
            line += " lives at #{person.apartments[0].building.address} " +
              "apartment #{person.apartments[0].apt_num}"
          else
            line += " has #{apts} apartments!"
        end
 
        # Now put the line into the table using
        # the puts_table_row utility method.
        puts_table_row line
      end
    end
    puts
  end
 
  # Adding people to our persons array is pretty simple...
  def add_person
    # Start with the heading.
    puts_heading "Add a new person..."
 
    # Now start asking for data, beginning with the name.
    puts_request "Please enter the person's name:"
    name = gets.chomp
 
    # They can add an age (but it's optional)
    puts_request "Optionally, enter the person's age:"
    age = gets.chomp.to_i
 
    # OK, let's build the huge options hash for all the Person attributes!
    options = {}
    options[:age] = age # er... that's all of them? Really?
 
    # Make the person
    person = Person.new(name, options)
 
    # Did it work?
    if person
      # Yes! Add him/her to our persons array, then
      # send a message to the user.
      @persons << person
      puts_message "#{person.name} has been added."
    else
      # Doh! Failure is not an option. But we'd better be ready anyway.
      puts_message "Failed to add the new person. Sorry!", true
    end
    puts
  end
 
  # Removing people is only slightly more complicated than adding them.
  # We have to make sure we remove them as tenants in whatever apartments
  # they are in. Right?
  def remove_person
    # Can't remove a person if we don't have any!
    if @persons.empty?
      puts_message "Can't remove a person until you've added one. " +
        "Enter 7 to do so."
      return "Try again?"
    end
 
    # Start with the heading.
    puts_heading "Remove a person..."
 
    # Now prompt them to choose a person to remove.
    req = "Please choose the person by number:"
    puts_request req
    puts_separator :width => req.length
 
    # Now we'll loop through the persons array and use the index
    # as the number, add age in parentheses only if we have it,
    # and list an address, if we have one
    @persons.each_index do |idx|
      person = @persons[idx]
      str = "#{idx + 1}: #{person.name}"
      unless person.age.nil?
        str += " (#{person.age})"
      end
      unless person.apartments.empty?
        apt = person.apartments[0]
        str += " who rents apartment #{apt.apt_num} " +
          "at #{apt.building.address}"
      end
      puts_option str
    end
 
    # Let's get the number of the person, convert to integer,
    # and subtract 1 to get the index.
    idx = gets.chomp.to_i - 1
 
    # And check to make sure the index is in range...
    if idx >= 0 and idx < @persons.length
      person = @persons[idx]
 
      # Better double check!
      puts_message "Are you sure? Enter X to remove, " +
        "anything else to cancel.", true
 
      # If it's X, we're good to delete...
      if gets.chomp.downcase == 'x'
        # Remove this person from the tenants list
        # on any and all apartments.
        person.remove_all_apartments
 
        # Now delete this person from our persons list.
        @persons.delete person
 
        # Show the list of persons to make clear that he/she is gone.
        # Then show a success message.
        show_persons
        puts_message "#{person.name} has been removed " +
          "from the rental application."
      else
        # They changed their mind... show that the person is still there.
        # Then show a cancelation message to reassure them.
        show_persons
        puts_message "Removal of #{person.name} has been canceled."
      end
    else
      # Maybe they can't read? Or count?
      puts_message "I'm sorry. I didn't get the person. " +
        "Please try again.", true
    end
  end
 
  # Adding tenants is a pain. We have to get the person,
  # AND the apartment, which means getting the building first.
  # So there's a lot to choose from! Obviously, our interface is
  # kind of primitive... even with a thousand plus lines of code!
  def add_new_tenant
    # We can also test up front, right?
    # Do we have buildings? If so, do any have apartments?
    if @buildings.empty?
      puts_message "You must first add buildings " +
        "before you can add tenants!"
      return "Try again!"
    else
      if (@buildings.values.map {|b| b.apartments.keys.length }.max) < 1
        puts_message "You must first add apartments " +
          "before you can add tenants!"
        return "Try again!"
      end
    end
 
    # Do we have people to add?
    if @persons.empty?
      puts_message "You must first add persons " +
        "before you can make them tenants!"
      return "Try again!"
    end
 
    # Start with the heading.
    puts_heading "Add a tenant to an apartment"
 
    # Now prompt them to choose a person to remove.
    req = "Please choose the person by number:"
    puts_request req
    puts_separator :width => req.length
 
    # Now we'll loop through the persons array and use the index
    # as the number, add age in parentheses only if we have it,
    # and list an address, if we have one.
    @persons.each_index do |idx|
      person = @persons[idx]
      str = "#{idx + 1}: #{person.name}"
      unless person.age.nil?
        str += " (#{person.age})"
      end
      unless person.apartments.empty?
        apt = person.apartments[0]
        str += " who rents apartment #{apt.apt_num} " +
          "at #{apt.building.address}"
      end
      puts_option str
    end
 
    # Let's get the number of the person, convert to integer,
    # and subtract 1 to get the index.
    idx = gets.chomp.to_i - 1
 
    # And check to make sure the index is in range...
    if idx >= 0 and idx < @persons.length
      person = @persons[idx] # OK, we got the person...
 
      # Let's get an array of keys for only those buildings with apartments
      keys = @buildings.reject {|k,v| v.apartments.empty? }.keys
 
      # Check to make sure we got some apartments
      # (yes, we tested above, but let's be sure)
      if keys.empty?
        # Somehow we goofed
        puts_message "Sorry! There don't seem to be " +
          "any apartments available. Add some?", true
      else
        # Add the prompts
        req = "Now, please select a building by number:"
        puts_request req
        puts_separator :width => req.length
 
        # Now add the option rows, one for each building
        keys.each_index do |i|
          key = keys[i]
          
          # The index (shifted to 1-based): the address of the building.
          puts_option "#{i + 1}: #{key}" 
        end
 
        # Get the building number
        i = gets.chomp.to_i - 1
 
        # Check that it's in the range of indices...
        if i >= 0 and i < keys.length
          # We got a building
          # Let's check for apartments
          key = keys[i]
          building = @buildings[key]
          apartments = building.apartments
 
          if apartments.empty?
            puts_message "That building has no apartments!", true
            return "Try again?"
          else
            # Get the keys to the apartments hash as an array
            apt_keys = apartments.keys
 
            # We're good to go. Now to list the apartments
            req = "Please select an apartment by number:"
            puts_request req
            puts_separator :width => req.length
 
            # List the apartment options
            apt_keys.each_index do |j|
              # The key is the apartment number.
              k = apt_keys[j] 
              
              # Index (plus 1 for 1-based): apt_num.
              puts_option "#{j + 1}: #{k}" 
            end
 
            # Get the user's choice of apartment
            a = gets.chomp.to_i - 1
 
            # Check that it's in range
            if a >= 0 and a < apt_keys.length
              # Finally! We have what we need to complete the process!
              k = apt_keys[a]
              apartment = apartments[k]
 
              # Now we use this handy method on the apartment
              # to add the tenant. We could also have added
              # the apartment to the tenant with
              # person.add_apartment
              apartment.add_tenant(person)
 
              puts_message "#{person.name} has been added " +
                "to apartment #{k} at #{key}."
            else
              # Whoops!
              puts_message "Sorry, I can't find an apartment " +
                "with that number.", true
            end
          end
        else
          # That's not an option...
          puts_message "Sorry, I can't find a building " +
            "with that number.", true
        end
      end
    else
      # That's not an option...
      puts_message "Sorry, I can't find a person with that number.", true
    end
 
  end
 
  # Removing a tenant is pretty much the same as adding one. Same steps,
  # but at least we can come from the tenant side and as most tenants
  # have only one apartment, we can do the elimination in one step
  # (with a check).
  def remove_old_tenant
    # If there are no persons to remove as tenants, wtf?
    if @persons.empty? or @persons.map { |p| p.apartments.length }.max < 1
      puts_message "You must first have tenants before you can remove one."
      return "Try again?"
    end
 
    # Let's give them a list of persons to choose from, but reject
    # any person who has no associated apartments, thus simplifying things
    persons = @persons.reject { |p| p.apartments.length < 1 }
 
    # The heading and separator
    req = "Please select the tenant to remove:"
    puts_heading req
    puts_separator :width => req.length
 
    # Loop through persons and list the options
    persons.each_index do |idx|
      person = persons[idx]
      if person.apartments.length == 1
        apt = person.apartments[0]
        puts_option "#{idx + 1}: #{person.name} " +
          "in apartment #{apt.apt_num} at #{apt.building.address}"
      else
        puts_option "#{idx + 1}: #{person.name} " +
          "who has #{person.apartments.length} apartments"
      end
    end
    puts
 
    # Get the index of the person to remove
    idx = gets.chomp.to_i - 1
 
    # Check that index is in range...
    if idx >= 0 and idx < persons.length
      # Get the person
      person = persons[idx]
 
      # If the person has only one apartment, we can just remove
      # him/her from that apartment; else, we need to ask the user
      # which apartment to remove him/her from.
      if person.apartments.length == 1
        apartment = person.apartments[0]
      elsif person.apartments.length > 0
        req = "Select which apartment you wish " +
          "to remove #{person.name} from by number:"
        puts_request req
        puts_separator :width => req.length
        apartments = person.apartments
 
        # List the apartments in a numbered, 1-based list
        apartments.each_index do |i|
          puts_option "#{i + 1}: #{apartments[i].apt_num} " +
            "at #{apartments[i].building.address}"
        end
        puts
 
        # Get the user's choice
        i = gets.chomp.to_i - 1
 
        # Check that it's in range
        if i >= 0 and i < apartments.length
          apartment = apartments[i]
        else
          puts_message "Sorry, I can't find an apartment " +
            "with that number", true
          return "Try again?"
        end
      else
        puts_message "#{person.name} is not currently " +
          "a tenant in any apartment managed here."
        return "Try again?"
      end
 
      # Now that we have the apartment and the tenant, let's remove him/her
      apartment.remove_tenant(person)
 
      # Alert the user
      puts_message "#{person.name} has been removed " +
        "from apartment #{apartment.apt_num} " +
        "at #{apartment.building.address}"
    else
      puts_message "Sorry, I can't find a person with that number.", true
    end
  end
 
  # You should be familiar enough with these now to know what's going on
  # But why are these *inside* the RentalApp class? Any ideas?
  class Building
 
    attr_accessor :address, :style, :has_doorman,
      :has_elevator, :apartments
 
    def initialize(address, options = {})
      @address = address
      @style = options[:style]
      @has_doorman = options[:has_doorman]
      @has_elevator = options[:has_elevator]
      @apartments = options[:apartments] || {}
    end
 
    def add_apartment(apartment)
      @apartments[apartment.apt_num] = apartment
      apartment.building = self
    end
 
    def remove_apartment(apartment)
      apartment.building = nil
      @apartments.delete apartment.apt_num
    end
 
    def remove_all_apartments
      @apartments.each do |apartment|
        apartment.building = nil
      end
      @apartments = {}
    end
 
    def to_s
      puts address
    end
 
  end
 
  class Apartment
 
    attr_accessor :apt_num, :size, :rent, :is_furnished,
      :num_beds, :num_loos, :building, :tenants
 
    def initialize(apt_num, options = {})
      @apt_num = apt_num
      @size = options[:size]
      @rent = options[:rent]
      @is_furnished = options[:is_furnished]
      @num_beds = options[:num_beds]
      @num_loos = options[:num_loos]
      @building = options[:building]
      @tenants = options[:tenants] || []
    end
 
    def add_tenant(tenant)
      @tenants << tenant
      tenant.apartments << self
    end
 
    def remove_tenant(tenant)
      tenant.apartments.delete self
      @tenants.delete tenant
    end
 
    def remove_all_tenants
      @tenants.each do |tenant|
        tenant.apartments.delete self
      end
      @tenants = []
    end
 
    def show_tenants
      puts "Tenants:"
      @tenants.each do |tenant|
        print "  #{tenant.name}"
        print ", age: #{tenant.age}" unless tenant.age.nil?
        puts
      end
    end
 
    def to_s
      puts "Apartment number #{apt_num}"
    end
 
  end
 
  class Person
 
    attr_accessor :name, :age, :apartments
 
    def initialize(name, options = {})
      @name = name
      @age = options[:age]
      @apartments = options[:apartments] || []
    end
 
    def add_apartment(apartment)
      apartment.add_tenant(self)
      @apartments << apartment
    end
 
    def remove_apartment(apartment)
      apartment.remove_tenant(self)
      @apartments.delete apartment
    end
 
    def remove_all_apartments
      @apartments.each do |apartment|
        apartment.remove_tenant(self)
      end
      @apartments = []
    end
 
    def to_s
      puts "#{name}" + unless @age.nil? then " (#{age})" end
    end
 
  end
end
 
r = RentalApp.new
r.run