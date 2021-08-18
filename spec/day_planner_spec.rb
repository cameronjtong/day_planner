require "rspec"
require_relative "../day_planner"

describe "a day planner" do
  let(:test_file) do
    ENV["DAY_PLANNER_FILENAME"] = "./task_list_test.yml"
  end

  before { remove_test_file }

  it "creates lists" do
    inputs = ["Grocery List"]

    lists = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
  end

  it "adds tasks" do
    inputs = ["Grocery List", "apples"]

    lists = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => ["apples"])
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

  def remove_test_file
    system "rm #{test_file}"
  end
end
