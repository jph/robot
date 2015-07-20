require 'spec_helper'
require_relative '../lib/cool_robot.rb'
require_relative '../lib/table.rb'

RSpec.describe CoolRobot do
  before(:all) do
    @table = Table.new 5, 5
  end

  context "#report" do
    it "reports correctly after init" do
      robot = CoolRobot.new @table, ['PLACE 0,0,NORTH']
      expect( robot.report ).to eq([0, 0, 'NORTH'])
    end
  end

  context "#move" do
    it "moves NORTH when given valid commands" do
      robot = CoolRobot.new @table, ['PLACE 0,0,NORTH', 'MOVE', 'MOVE']
      expect( robot.report ).to eq([0, 2, 'NORTH'])
    end

    it "moves EAST when given valid commands" do
      robot = CoolRobot.new @table, ['PLACE 0,0,EAST', 'MOVE', 'MOVE']
      expect( robot.report ).to eq([2, 0, 'EAST'])
    end

    it "moves WEST when given valid commands" do
      robot = CoolRobot.new @table, ['PLACE 2,0,WEST', 'MOVE', 'MOVE']
      expect( robot.report ).to eq([0, 0, 'WEST'])
    end

    it "moves SOUTH when given valid commands" do
      robot = CoolRobot.new @table, ['PLACE 0,2,SOUTH', 'MOVE', 'MOVE']
      expect( robot.report ).to eq([0, 0, 'SOUTH'])
    end

    it "outputs `Can't move, next position is out of bounds` when attempting to move NORTH out of bounds" do
      expect( STDOUT ).to receive(:puts).with("Can't move, next position is out of bounds. Table: #{@table.bounds}")
      robot = CoolRobot.new @table, ['PLACE 0,4,NORTH', 'MOVE']
    end

    it "outputs `Can't move, next position is out of bounds` when attempting to move EAST out of bounds" do
      expect( STDOUT ).to receive(:puts).with("Can't move, next position is out of bounds. Table: #{@table.bounds}")
      robot = CoolRobot.new @table, ['PLACE 4,0,EAST', 'MOVE']
    end

    it "outputs `Can't move, next position is out of bounds` when attempting to move WEST out of bounds" do
      expect( STDOUT ).to receive(:puts).with("Can't move, next position is out of bounds. Table: #{@table.bounds}")
      robot = CoolRobot.new @table, ['PLACE 0,0,WEST', 'MOVE']
    end

    it "outputs `Can't move, next position is out of bounds` when attempting to move SOUTH out of bounds" do
      expect( STDOUT ).to receive(:puts).with("Can't move, next position is out of bounds. Table: #{@table.bounds}")
      robot = CoolRobot.new @table, ['PLACE 0,0,SOUTH', 'MOVE']
    end
  end

  context "#turn_left" do
    it "turns left" do
      robot = CoolRobot.new @table, ['PLACE 0,0,NORTH', 'LEFT']
      expect(robot.report).to eq([0, 0, 'WEST'])
    end

    it "moves 5 NORTH then 5 WEST after taking a lh turn" do
      expect( STDOUT ).to_not receive(:puts)
      robot = CoolRobot.new @table, ['PLACE 4,0,NORTH', 'MOVE', 'MOVE', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'MOVE', 'MOVE', 'MOVE']
      expect( robot.report ).to eq([0, 4, 'WEST'])
    end
  end

  context "#turn_right" do
    it "turns right" do
      robot = CoolRobot.new @table, ['PLACE 0,0,NORTH', 'RIGHT']
      expect(robot.report).to eq([0, 0, 'EAST'])
    end

    it "moves 5 NORTH then 5 EAST after taking a rh turn" do
      expect( STDOUT ).to_not receive(:puts)
      robot = CoolRobot.new @table, ['PLACE 0,0,NORTH', 'MOVE', 'MOVE', 'MOVE', 'MOVE', 'RIGHT', 'MOVE', 'MOVE', 'MOVE', 'MOVE']
      expect( robot.report ).to eq([4, 4, 'EAST'])
    end
  end

  context "#history" do
    it "displays history correctly" do
      robot = CoolRobot.new @table, ['PLACE 0,0,EAST', 'MOVE', 'RIGHT', 'LEFT', 'MOVE']
      expect( robot.display_history ).to eq(
          "PLACE 0,0,EAST\n" +
          "MOVE\n" + 
          "RIGHT\n" +
          "LEFT\n" +
          "MOVE"
        )
    end
  end
end
