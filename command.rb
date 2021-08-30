class Command < Struct.new(:lists, :input)
  def self.handle_command(lists, input)
    input = input.strip
    registry.find do |candidate|
      candidate.handles?(lists, input)
    end.new(lists, input).call
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
  def self.handles?(_lists, input)
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
  def self.handles?(_lists, input)
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
  def self.handles?(_lists, input)
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
  def self.handles?(_lists, input)
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
  def self.handles?(_lists, input)
    input == ""
  end

  def call
    # no-op
  end
end

class DeleteList < Command
  def self.handles?(_lists, input)
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
  def self.handles?(_lists, input)
    input.downcase == "help"
  end

  def help
    ["help", "Display help page"]
  end

  def call
    Command.registry.each do |command_class|
      if command_class.new.help
        command, explanation = command_class.new.help
        puts format("%10s - %s", command, explanation)
      else
        # no-op
      end
    end
  end
end

class AddTaskWhenNoLists < Command
  def self.handles?(lists, _input)
    lists.lists.empty?
  end

  def call
    puts "Error: No lists, please enter list first."
  end
end

# AddTask needs to be last
class AddTask < Command
  def self.handles?(_lists, _input)
    true
  end

  def help
    ["<task>", "Add task"]
  end

  def call
    lists.add_task(input)
  end
end
