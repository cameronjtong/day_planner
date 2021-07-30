class ListCollection
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

  def clear
  end

  def add_task(task)
    lists[@current_list_name] << task
  end

  def add_list(list_name)
    lists[list_name] = []
    @current_list_name = list_name
  end

  private

  def format_task(task, index)
    ["  #{index + 1}.", task].join(" ")
  end
end
