require "rspec"
require_relative "../day_planner"

describe "a day planner" do
  let(:day_planner) { DayPlanner.new }

  it "creates lists" do
    expect { day_planner.main }.to output(//).to_stdout
    TaskRepository.persist do |lists|
      expect(lists.list_names.first).to eq("Reading List")
    end
  end
end
