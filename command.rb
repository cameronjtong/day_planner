class Command < Struct.new(:lists, :input)
  def self.handle_command(lists, input)
    registry.find do |candidate|
      candidate.handles?(input)
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
  def self.handles?(input)
    input =~ /^-\d/
  end

  def call
    task_index = input.to_i.abs - 1
    lists.delete_at(task_index)
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

class MoveCurrentListOneUp < Command
  def self.handles?(input)
    input =~ /\^/
  end

  def call
    lists.move_current_list_one_up
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
