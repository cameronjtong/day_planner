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
