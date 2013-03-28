def printme (name, options={})
	puts name
	puts options[:age] if options.has_key?(:age)
	puts options[:ht] if options.has_key?(:ht)
	puts options[:wt] if options.has_key?(:wt)
	puts options[:iq] if options.has_key?(:iq)
end