class Command < Struct.new(:lists, :input)
  def self.handle_command(lists, input)
    input = input.strip

    registry.map do |command_class|
      command_class.new(lists, input)
    end.find(&:match?).call
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

  def <=>(other)
    help <=> other.help
  end
end

class DeleteTask < Command
  def match?
    input =~ /^dt /
  end

  def help
    ["dt <task-number>", "Delete task from current list"]
  end

  def call
    task_index = input[3..].to_i.abs - 1
    lists.delete_at(task_index)
  end
end

class AddList < Command
  def match?
    input =~ /^al /
  end

  def help
    ["al <list-name>", "Add list"]
  end

  def call
    lists.add_list(input[3..])
  end
end

class MoveCurrentListOneUp < Command
  def match?
    input == "mu"
  end

  def help
    ["mu", "Move current list one up"]
  end

  def call
    lists.move_current_list_one_up
  end
end

class MoveCurrentListOneDown < Command
  def match?
    input == "md"
  end

  def help
    ["md", "Move current list one down"]
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
    input == "dl"
  end

  def help
    ["dl", "Delete current list"]
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
    puts
    Command.registry
      .map(&:new)
      .select(&:help)
      .sort
      .each do |candidate|
        command, explanation = candidate.help
        puts format("%20s - %s", command, explanation)
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
    input =~ /^at /
  end

  def help
    ["at <task>", "Add task to current list"]
  end

  def call
    lists.add_task(input[3..])
  end
end
