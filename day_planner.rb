# add items to specific time slots
# add associated start and end times
# storage of tasks
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
require "yaml/store"

system "clear"

store = YAML::Store.new("./task_list.yml")
tasks = nil
store.transaction do
  tasks = store["tasks"]
end

loop do
  puts "-- Tasks --"
  puts tasks
  puts
  print "Enter Task Here => "
  input = gets
  tasks << input
  store.transaction do
    store["tasks"] = tasks
  end
  puts
end
