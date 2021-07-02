# add items to specific time slots
# add associated start and end times
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
require "yaml/store"

system "clear"

TEST_INPUTS = ["12:00 13:00 lift weights"]

def format_task(task)
  parsed_task = task.split
  start_time, end_time, *task_description = parsed_task
  [start_time, end_time, task_description].join(" ")
end

def get_string
  if true
    test_input
  else
    gets
  end
end

def test_input
  TEST_INPUTS.shift || exit
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
  input = get_string
  tasks << input
  store.transaction do
    store["tasks"] = tasks
  end
  puts
end
