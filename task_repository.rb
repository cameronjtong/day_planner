class TaskRepository
  def self.persist
    build_store.transaction do |store|
      tasks = store["tasks"].compact || []
      yield(tasks)
      store["tasks"] = tasks
    end
  end

  private

  def self.build_store
    YAML::Store.new(ENV["DAY_PLANNER_FILENAME"])
  end
end
