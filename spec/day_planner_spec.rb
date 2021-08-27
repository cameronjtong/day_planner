require "rspec"
require_relative "../day_planner"

describe "a day planner" do
  let(:test_file) do
    ENV["DAY_PLANNER_FILENAME"] = "./task_list_test.yml"
  end

  before { remove_test_file }

  it "creates lists" do
    inputs = ["Grocery List"]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
  end

  it "adds tasks" do
    inputs = ["Grocery List", "apples"]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => ["apples"])
  end

  it "deletes tasks" do
    inputs = ["Grocery List", "apples", "-1"]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
  end

  it "deletes lists" do
    inputs = ["Grocery List", "-"]

    lists, = process_inputs(inputs)

    expect(lists).to eq({})
  end

  it "can move up one list" do
    inputs = ["Grocery List", "Reading List", "^"]

    _, current_list_name = process_inputs(inputs)

    expect(current_list_name).to eq("Grocery List")
  end

  it "can move one list down" do
    inputs = ["Grocery List", "Reading List", "^", "v"]

    _, current_list_name = process_inputs(inputs)

    expect(current_list_name).to eq("Reading List")
  end

  it "ignores empty input" do
    inputs = ["Grocery List", "    "]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
  end

  it "handles input when no current list" do
    inputs = ["apples"]

    lists, = process_inputs(inputs)

    expect(lists).to be_empty
  end

  def process_inputs(inputs)
    day_planner = DayPlanner.new(inputs)
    expect { day_planner.main }.to output(//).to_stdout
    [task_lists.lists, task_lists.current_list_name]
  end

  def task_lists
    TaskRepository.persist do |lists|
      return lists
    end
  end

  def remove_test_file
    system "rm #{test_file}"
  end
end
