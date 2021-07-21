# add items to specific time slots
# add associated start and end times
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
require "yaml/store"
require_relative "task_repository"

class DayPlanner
  TEST_INPUTS = ["12:00 13:00 lift weights", "14:00 14:45 read refactoring", "clear"]

  def main
    system "clear"

    loop do
      TaskRepository.persist do |tasks|
        display_tasks(tasks)
        display_prompt
        handle_input(tasks)
        puts
      end
    end
  end

  private

  def display_tasks(tasks)
    puts "-- Tasks --"
    puts tasks.map(&method(:format_task))
    puts
  end

  def display_prompt
    print "Enter Task Here => "
  end

  def handle_input(tasks)
    input = get_string
    case input
    when "clear"
      tasks.clear
    else
      tasks << input
    end
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
      gets.chomp
    end
  end

  def test_mode?
    ENV["DAY_PLANNER_TEST_MODE"] == "true"
  end

  def test_input
    TEST_INPUTS.shift || exit
  end
end

task_test = DayPlanner.new
task_test.main
