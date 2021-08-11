require "rspec"
require_relative "../day_planner"

ENV["DAY_PLANNER_FILENAME"] = "./task_list_test.yml"

describe "a day planner" do
  it "creates lists" do
    test_inputs = ["Grocery List", "apples", "bread", "-2", "Reading List", "^ ", "v ", "v ", " ", "-"]
    day_planner = DayPlanner.new(test_inputs)
    expect { day_planner.main }.to output(//).to_stdout
    TaskRepository.persist do |lists|
      expect(lists.list_names.first).to eq("Reading List")
    end
  end
end
