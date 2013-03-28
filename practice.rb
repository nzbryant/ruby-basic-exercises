
def play_again
  puts "Try again? (Y/n)"
  ans = gets.chomp
  ans.downcase == "y" || ans == ""
end

def get_answers(queries)
  queries.each do |key,value|
    puts key
    queries[key] = gets.chomp
  end
end

begin
  q1 = "What is your name?"
  q2 = "What is your favorite color?"
  queries = { q1 => nil, q2 => nil }
  get_answers(queries)
  queries.each do |k,v|
    puts k + " = " + (v || "nil")
  end
end while play_again