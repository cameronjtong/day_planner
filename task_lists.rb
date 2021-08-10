class TaskLists
  attr_reader :lists

  def initialize
    @lists = {}
  end

  def display_lists
    lists.each do |list_name, tasks|
      puts
      if @current_list_name == list_name
        puts "  -- #{list_name} -- <<- Current list"
      else
        puts "  -- #{list_name} --"
      end
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

  def move_current_list_one_up
    previous_list_index = lists.keys.index(@current_list_name) - 1
    @current_list_name = lists.keys[previous_list_index]
  end

  def move_current_list_one_down
    next_list_index = lists.keys.index(@current_list_name) + 1
    @current_list_name = lists.keys[next_list_index]
  end

  private

  def current_list
    lists[@current_list_name]
  end

  def format_task(task, index)
    ["  #{index + 1}.", task].join(" ")
  end
end
