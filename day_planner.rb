# add items to specific time slots
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
system "clear"

tasks = []
loop do
  print "Enter Task Here => "
  input = gets
  tasks << input
  puts
  puts "-- Tasks --"
  puts tasks
  puts
end

