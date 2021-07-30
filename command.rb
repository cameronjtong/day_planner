class Command < Struct.new(:tasks, :lists, :input)
  def self.handle_command(tasks, lists, input)
    registry.find do |candidate|
      candidate.handles?(input)
    end.new(tasks, lists, input).call
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
    lists.clear
  end
end

class DeleteTask < Command
  def self.handles?(input)
    input =~ /^-\d/
  end

  def call
    task_index = input.to_i.abs - 1
    tasks.delete_at(task_index)
  end
end

class AddList < Command
  def self.handles?(input)
    input.downcase.include?("list")
  end

  def call
    lists.add_list(input)
  end
end

class AddTask < Command
  def self.handles?(_input)
    true
  end

  def call
    lists.add_task(input)
  end
end
