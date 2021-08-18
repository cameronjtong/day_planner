require "rspec"
require_relative "../day_planner"

ENV["DAY_PLANNER_FILENAME"] = "./task_list_test.yml"
FILENAME = ENV["DAY_PLANNER_FILENAME"]

describe "a day planner" do
  before { system "rm #{FILENAME}" }

  it "creates lists" do
    test_inputs = ["Grocery List"]

    process_inputs(test_inputs)

    expect(lists.list_names.first).to eq("Grocery List")
  end

  def process_inputs(test_inputs)
    day_planner = DayPlanner.new(test_inputs)
    expect { day_planner.main }.to output(//).to_stdout
  end

  def lists
    TaskRepository.persist do |task_lists|
      return task_lists
    end
  end
end
