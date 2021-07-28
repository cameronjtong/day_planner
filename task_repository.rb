require_relative "list_collection"
class TaskRepository
  def self.persist
    build_store.transaction do |store|
      tasks = store["tasks"] || []
      list_collection = store["list_collection"] || ListCollection.new
      yield(tasks, list_collection)
      store["tasks"] = tasks
      store["list_collection"] = list_collection
    end
  end

  private

  def self.build_store
    YAML::Store.new(ENV["DAY_PLANNER_FILENAME"])
  end
end
