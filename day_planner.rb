require "yaml/store"
require_relative "command"
require_relative "task_repository"

class DayPlanner
  TEST_INPUTS = ["Grocery List", "apples", "bread", "-2", "Reading List", "^", "v", "v"]

  def main
    system "clear"

    loop do
      TaskRepository.persist do |lists|
        display_tasks(lists)
        display_prompt
        handle_input(lists)
        puts
      end
    end
  end

  private

  def display_tasks(lists)
    lists.display_lists
  end

  def display_prompt
    print "Enter task here => "
  end

  def handle_input(lists)
    input = get_string
    Command.handle_command(lists, input)
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
