def run(a, &block)
  puts "hello"
  yield a
  puts "goodbye"
end

run "A" do |a|
  puts a * 2
end   

puts File.dirname(__FILE__)