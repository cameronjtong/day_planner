# add items to specific time slots
# add associated start and end times
# storage of tasks
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
system "clear"
require "yaml/store"

store = YAML::Store.new "./task_list.yml"
tasks = nil
store.transaction do
  tasks = store["tasks"]
end

loop do
  print "Enter Task Here => "
  input = gets
  tasks << input
  store.transaction do
    store["tasks"] = tasks
  end
  puts
  puts "-- Tasks --"
  puts tasks
  puts
end
