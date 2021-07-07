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

def test_mode?
  true
end

def get_string
  if test_mode?
    test_input
  else
    gets
  end
end

def test_input
  TEST_INPUTS.shift || exit
end

def build_store
  if test_mode?
    YAML::Store.new("./task_list_test.yml")
  else
    YAML::Store.new("./task_list.yml")
  end
end

store = build_store
tasks = nil
store.transaction do
  tasks = store["tasks"] || []
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
  store.transaction { store["tasks"] = [] } if TEST_INPUTS.empty?

  puts
end
