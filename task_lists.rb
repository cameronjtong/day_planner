class TaskLists
  attr_reader :lists

  def initialize
    @lists = {}
  end

  def display_lists
    lists.each do |list_name, tasks|
      puts
      puts "  -- #{list_name} --"
      puts "  (no tasks)" if tasks.empty?
      puts tasks.map.with_index { |task, index| format_task(task, index) }
      puts
    end
  end

  def add_task(task)
    current_list << task
  end

  def add_list(list_name)
    lists[list_name] = []
    @current_list_name = list_name
  end

  def delete_at(task_index)
    current_list.delete_at(task_index)
  end

  private

  def current_list
    lists[@current_list_name]
  end

  def format_task(task, index)
    ["  #{index + 1}.", task].join(" ")
  end
end
