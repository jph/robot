require 'spec_helper'
require_relative '../lib/cool_robot.rb'
require_relative '../lib/table.rb'

RSpec.describe CoolRobot do
  it "becomes initialized" do
    table = Table.new 5, 5
    robot = CoolRobot.new table, ['PLACE 0,0,NORTH']
    expect( robot.report ).to eq([0, 0, 'NORTH'])
  end
end
