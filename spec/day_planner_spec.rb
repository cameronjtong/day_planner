require "rspec"
require_relative "../day_planner"

ENV["DAY_PLANNER_FILENAME"] = "./task_list_test.yml"
FILENAME = ENV["DAY_PLANNER_FILENAME"]

describe "a day planner" do
  before { system "rm #{FILENAME}" }

  it "creates lists" do
    inputs = ["Grocery List"]

    lists = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
  end

  def process_inputs(inputs)
    day_planner = DayPlanner.new(inputs)
    expect { day_planner.main }.to output(//).to_stdout
    task_lists
  end

  def task_lists
    TaskRepository.persist do |lists|
      return lists.lists
    end
  end
end
