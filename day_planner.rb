# add items to specific time slots
# add associated start and end times
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
require "yaml/store"

system "clear"

def format_task(task)
  parsed_task = task.split
  [parsed_task[0], parsed_task[1], parsed_task[2..]].join(" ")
end

store = YAML::Store.new("./task_list.yml")
tasks = nil
store.transaction do
  tasks = store["tasks"]
end

loop do
  puts "-- Tasks --"
  puts tasks.map(&method(:format_task))
  puts
  print "Enter Task Here => "
  input = gets
  tasks << input
  store.transaction do
    store["tasks"] = tasks
  end
  puts
end
