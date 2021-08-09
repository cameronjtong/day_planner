require_relative "task_lists"

class TaskRepository
  def self.persist
    build_store.transaction do |store|
      task_lists = store["task_lists"] || TaskLists.new
      yield(task_lists)
      store["task_lists"] = task_lists
    end
  end

  private

  def self.build_store
    YAML::Store.new(ENV["DAY_PLANNER_FILENAME"])
  end
end
