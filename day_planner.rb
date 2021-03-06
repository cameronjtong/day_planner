require "yaml/store"
require_relative "command"
require_relative "task_repository"

class DayPlanner
  class CustomError < StandardError
  end

  def initialize(test_inputs = nil)
    @test_inputs = test_inputs
  end

  def main
    system "clear"

    loop do
      TaskRepository.persist do |lists|
        display_tasks(lists)
        display_prompt
        handle_input(lists)
      end
    end
  rescue CustomError
  end

  private

  def display_tasks(lists)
    lists.display_lists
  end

  def display_prompt
    print "\nEnter command here => "
  end

  def handle_input(lists)
    input = get_string
    Command.handle_command(lists, input)
  end

  def get_string
    if @test_inputs
      input = test_input
      print input
      input
    else
      gets.chomp
    end
  end

  def test_input
    @test_inputs.shift || raise(CustomError)
  end
end
