class Command < Struct.new(:lists, :input)
  def self.handle_command(lists, input)
    input = input.strip

    registry.map do |command_class|
      command_class.new(lists, input)
    end.find(&:handles?).call
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
  def handles?
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
  def handles?
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
  def handles?
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
  def handles?
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
  def handles?
    input == ""
  end

  def call
    # no-op
  end
end

class DeleteList < Command
  def handles?
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
  def handles?
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
  def handles?
    lists.lists.empty?
  end

  def call
    puts "Error: No lists, please enter list first."
  end
end

# AddTask needs to be last
class AddTask < Command
  def handles?
    true
  end

  def help
    ["<task>", "Add task"]
  end

  def call
    lists.add_task(input)
  end
end
