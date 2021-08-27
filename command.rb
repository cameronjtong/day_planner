class Command < Struct.new(:lists, :input)
  def self.handle_command(lists, input)
    input = input.strip
    registry.find do |candidate|
      candidate.handles?(input, lists)
    end.new(lists, input).call
  end

  def self.inherited(candidate)
    registry << candidate
  end

  def self.registry
    @@registry ||= []
  end
end

class DeleteTask < Command
  def self.handles?(input, _lists)
    input =~ /^-\d/
  end

  def call
    task_index = input.to_i.abs - 1
    lists.delete_at(task_index)
  end
end

class AddList < Command
  def self.handles?(input, _lists)
    input.downcase.include?("list")
  end

  def call
    lists.add_list(input)
  end
end

class MoveCurrentListOneUp < Command
  def self.handles?(input, _lists)
    input == "^"
  end

  def call
    lists.move_current_list_one_up
  end
end

class MoveCurrentListOneDown < Command
  def self.handles?(input, _lists)
    input == "v"
  end

  def call
    lists.move_current_list_one_down
  end
end

class IgnoreEmptyInput < Command
  def self.handles?(input, _lists)
    input == ""
  end

  def call
    # no-op
  end
end

class DeleteList < Command
  def self.handles?(input, _lists)
    input == "-"
  end

  def call
    lists.delete_current_list
  end
end

class AddTaskWhenNoLists < Command
  def self.handles?(_input, lists)
    lists.lists.empty?
  end

  def call
    puts "Error: No lists, please enter list first."
  end
end

# AddTask needs to be last
class AddTask < Command
  def self.handles?(_input, _lists)
    true
  end

  def call
    lists.add_task(input)
  end
end
