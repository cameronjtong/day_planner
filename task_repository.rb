class TaskRepository
  attr_reader :store, :tasks

  def initialize
    @store = build_store
  end

  def build_store
    YAML::Store.new(ENV["DAY_PLANNER_FILENAME"])
  end

  def read_tasks
    store.transaction do
      @tasks = store["tasks"] || []
    end
  end

  def write_tasks
    store.transaction do
      store["tasks"] = tasks
    end
  end
end