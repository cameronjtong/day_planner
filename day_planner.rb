# add items to specific time slots
# add associated start and end times
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
require "yaml/store"
require_relative "command"
require_relative "task_repository"

class DayPlanner
  TEST_INPUTS = ["lift weights", "read refactoring-2", "-2", "clear"]

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
    puts
    puts "  -- Tasks --"
    puts "  (no tasks)" if tasks.empty?
    puts tasks.map.with_index { |task, index| format_task(task, index) }
    puts
  end

  def format_task(task, index)
    ["  #{index + 1}.", task].join(" ")
  end

  def display_prompt
    print "Enter task here => "
  end

  def handle_input(tasks)
    input = get_string
    Command.handle_command(tasks, input)
  end

  def get_string
    if test_mode?
      input = test_input
      print input
      input
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
