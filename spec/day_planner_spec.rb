require "rspec"
require_relative "../day_planner"

RSpec.configure do |c|
  c.filter_run_when_matching :focus
end

describe "a day planner" do
  let(:test_file) do
    ENV["DAY_PLANNER_FILENAME"] = "./task_list_test.yml"
  end

  before { remove_test_file }

  it "creates lists" do
    inputs = ["al Grocery List"]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
  end

  it "adds tasks" do
    inputs = ["al Grocery List", "at apples"]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => ["apples"])
  end

  it "deletes tasks" do
    inputs = ["al Grocery List", "at apples", "dt 1"]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
  end

  it "deletes lists" do
    inputs = ["al Grocery List", "dl"]

    lists, = process_inputs(inputs)

    expect(lists).to eq({})
  end

  it "can move up one list" do
    inputs = ["al Grocery List", "al Reading List", "mu"]

    _, current_list_name = process_inputs(inputs)

    expect(current_list_name).to eq("Grocery List")
  end

  it "can move one list down" do
    inputs = ["al Grocery List", "al Reading List", "mu", "md"]

    _, current_list_name = process_inputs(inputs)

    expect(current_list_name).to eq("Reading List")
  end

  it "ignores empty input" do
    inputs = ["al Grocery List", "    "]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
  end

  it "handles input when no current list" do
    inputs = ["at apples"]

    lists, = process_inputs(inputs)

    expect(lists).to be_empty
  end

  it "displays a help page" do
    inputs = ["al Grocery List", "help"]

    lists, = process_inputs(inputs)

    expect(lists).to eq("Grocery List" => [])
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
