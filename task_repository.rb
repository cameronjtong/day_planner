require_relative "list_collection"
class TaskRepository
  def self.persist
    build_store.transaction do |store|
      tasks = store["tasks"] || []
      lists = store["lists"] || ListCollection.new
      yield(tasks, lists)
      store["tasks"] = tasks
      store["lists"] = lists
    end
  end

  private

  def self.build_store
    YAML::Store.new(ENV["DAY_PLANNER_FILENAME"])
  end
end
