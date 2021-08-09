require_relative "task_lists"

class TaskRepository
  def self.persist
    build_store.transaction do |store|
      tasks = store["tasks"] || []
      task_lists = store["task_lists"] || TaskLists.new
      yield(tasks, task_lists)
      store["tasks"] = tasks
      store["task_lists"] = task_lists
    end
  end

  private

  def self.build_store
    YAML::Store.new(ENV["DAY_PLANNER_FILENAME"])
  end
end
