require "rspec"
require_relative "../day_planner"

describe "a day planner" do
  let(:day_planner) { DayPlanner.new }

  it "creates lists" do
    day_planner.main
    TaskRepository.persist do |lists|
      expect(lists.list_names.first).to eq("Reading List")
    end
  end
end
