class ListCollection
  attr_reader :lists

  def initialize
    @lists = []
  end

  def display_lists
    lists.each do |list|
      puts
      puts "  -- #{list} --"
      puts "  (no tasks)"
      puts
    end
  end

  def clear
  end

  def <<(arg)
    lists << arg
  end
end
