# table = Table.new 5, 5
# robot = Robot.new table, ['PLACE 0,0,NORTH', 'MOVE', 'MOVE']
# robot.report # => [0,2,'NORTH']

class CoolRobot
  DIRECTIONS = [:NORTH, :EAST, :WEST, :SOUTH]
  attr_accessor :position_x, :position_y
  attr_accessor :position # => [x, y]
  attr_accessor :sequence_position # => 6
  attr_accessor :direction
  attr_accessor :history
  attr_accessor :placed

  def initialize table, commands
    @table    = table
    @history  = []
    @position = []
    @placed   = false
    @commands = commands

    execute_sequence
  end

  def direction= direction
    if valid_direction?(direction)
      @direction = direction
    else
      raise CoolRobotError, "Can't deal with that direction, guy.\nValid directions are NORTH, EAST, WEST, SOUTH"
    end
  end

  def valid_direction? direction
    DIRECTIONS.include? direction.to_sym
  end

  def execute_sequence
    raise CoolRobotError, "Invalid sequence." if @commands.nil?
    @commands.each do |cmd|
      func, args = cmd.split(/(.+?)\s/).drop(1)
      case func
      when 'PLACE'
        clear_history
        @position_x = args.split(",")[0].to_i
        @position_y = args.split(",")[1].to_i
        raise CoolRobotError, "Out of bounds." unless @table.within_bounds? @position_x, @position_y
        @direction  = args.split(",")[2]
        @placed     = true
      when 'LEFT'
        turn_left
      when 'RIGHT'
        turn_right
      when 'REPORT'
        report
      when 'MOVE'
        move
      end
    end
  end

  def report
    [@position_x, @position_y, @direction]
  end

  def move
    if @table.within_bounds? *next_position
      @position_x = next_position[0]
      @position_y = next_position[1]
    else
      raise CoolRobotError, "Out of bounds."
    end
  end

  def turn_left
    
  end

  def turn_right
    
  end

  def next_position
    if @direction == "NORTH"
      next_pos = [@position_x, @position_y + 1]
    elsif @direction == "SOUTH"
      next_pos = [@position_x, @position_y - 1]
    elsif @direction == "EAST"
      next_pos = [@position_x + 1, @position_y]
    elsif @direction == "WEST"
      next_pos = [@position_x - 1, @position_y]
    end

    next_pos
  end

  def clear_history
    @history = []
  end
end

class CoolRobotError < StandardError; end
