# add items to specific time slots
# add associated start and end times
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
require "yaml/store"

class DayPlanner
  TEST_INPUTS = ["12:00 13:00 lift weights"]

  attr_reader :tasks

  def main
    system "clear"
    store = build_store
    read_tasks(store)

    loop do
      display_tasks
      display_prompt
      input = get_string
      tasks << input
      store.transaction do
        store["tasks"] = tasks
      end
      store.transaction { store["tasks"] = [] } if TEST_INPUTS.empty?

      puts
    end
  end

  private

  def build_store
    if test_mode?
      YAML::Store.new("./task_list_test.yml")
    else
      YAML::Store.new("./task_list.yml")
    end
  end

  def read_tasks(store)
    @tasks = nil
    store.transaction do
      @tasks = store["tasks"] || []
    end
  end

  def display_tasks
    puts "-- Tasks --"
    puts tasks.map(&method(:format_task))
    puts
  end

  def display_prompt
    print "Enter Task Here => "
  end

  def format_task(task)
    parsed_task = task.split
    start_time, end_time, *task_description = parsed_task
    [start_time, end_time, task_description].join(" ")
  end

  def get_string
    if test_mode?
      test_input
    else
      gets
    end
  end

  def test_mode?
    true
  end

  def test_input
    TEST_INPUTS.shift || exit
  end
end

task_test = DayPlanner.new
task_test.main
