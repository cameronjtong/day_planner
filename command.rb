class Command < Struct.new(:lists, :input)
  def self.handle_command(lists, input)
    p "A" * 20
    p lists
    p input
    input = input.strip

    registry.map do |command_class|
      p "-" * 20
      p command_class.new(lists, input)
    end.find do |command|
      p "=" * 20
      p command
      p command.match?
    end.call
  end

  def self.inherited(candidate)
    registry << candidate
  end

  def self.registry
    @@registry ||= []
  end

  def help
    # no-op
  end
end

class DeleteTask < Command
  def match?
    input =~ /^-\d/
  end

  def help
    ["-#", "Delete task"]
  end

  def call
    task_index = input.to_i.abs - 1
    lists.delete_at(task_index)
  end
end

class AddList < Command
  def match?
    input.downcase.include?("list")
  end

  def help
    ["Named list", "Create list"]
  end

  def call
    lists.add_list(input)
  end
end

class MoveCurrentListOneUp < Command
  def match?
    input == "^"
  end

  def help
    ["^", "Move current list one up"]
  end

  def call
    lists.move_current_list_one_up
  end
end

class MoveCurrentListOneDown < Command
  def match?
    input == "v"
  end

  def help
    ["v", "Move current list one down"]
  end

  def call
    lists.move_current_list_one_down
  end
end

class IgnoreEmptyInput < Command
  def match?
    input == ""
  end

  def call
    # no-op
  end
end

class DeleteList < Command
  def match?
    input == "-"
  end

  def help
    ["-", "Delete list"]
  end

  def call
    lists.delete_current_list
  end
end

class DisplayHelpPage < Command
  def match?
    input.downcase == "help"
  end

  def help
    ["help", "Display help page"]
  end

  def call
    Command.registry.each do |command_class|
      command, explanation = command_class.new.help
      next unless command

      puts format("%10s - %s", command, explanation)
    end
  end
end

class AddTaskWhenNoLists < Command
  def match?
    lists.lists.empty?
  end

  def call
    puts "Error: No lists, please enter list first."
  end
end

# AddTask needs to be last
class AddTask < Command
  def match?
    p "*" * 80
    input =~ /^at /
  end

  def help
    ["at <task>", "Add task"]
  end

  def call
    lists.add_task(input[3..])
  end
end
