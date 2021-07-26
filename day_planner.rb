# add items to specific time slots
# add associated start and end times
# be alerted if items overlap in time
# be prompted at the end of day planner item on compleition status
require "yaml/store"
require_relative "task_repository"

class DayPlanner
  TEST_INPUTS = ["12:00 13:00 lift weights", "14:00 14:45 read refactoring-2", "-2", "clear"]

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
    parsed_task = task.split
    start_time, end_time, *task_description = parsed_task
    ["  #{index + 1}.", start_time, end_time, task_description].join(" ")
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

class Command < Struct.new(:tasks, :input)
  def self.handle_command(tasks, input)
    registry.find do |candidate|
      candidate.handles?(input)
    end.new(tasks, input).call
  end

  def self.inherited(candidate)
    registry << candidate
  end

  def self.registry
    @@registry ||= []
  end
end

class ClearAllTasks < Command
  def self.handles?(input)
    input == "clear"
  end

  def call
    tasks.clear
  end
end

class DeleteTask < Command
  def self.handles?(input)
    input == /^-\d/
  end

  def call
    task_index = input.to_i.abs - 1
    tasks.delete_at(task_index)
  end
end

class AddTask < Command
  def self.handles?(_input)
    true
  end

  def call
    tasks << input
  end
end

task_test = DayPlanner.new
task_test.main
