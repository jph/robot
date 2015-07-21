# The main Toy Robot class.
class CoolRobot
  # Accepted directions that the robot can face.
  DIRECTIONS = [:NORTH, :EAST, :WEST, :SOUTH]
  # The instance's current position
  attr_accessor :position_x, :position_y
  # Current direction.
  attr_accessor :direction
  # Command history.
  attr_accessor :history
  # If the robot is placed on the table or not.
  attr_accessor :placed

  # Start up the robot and execute command sequence.
  #
  # * +table+: an instance of the Table class
  # * +commands+: an array of commands for the robot to perform
  def initialize table, commands
    @table    = table
    @history  = []
    @placed   = false
    @commands = commands

    execute_sequence
  end

  # Sets the robot to face a new direction, if it is valid.
  def direction= direction
    if valid_direction?(direction)
      @direction = direction
    else
      raise CoolRobotError, "Can't deal with that direction.\nValid directions are NORTH, EAST, WEST, SOUTH"
    end
  end

  # Checks for whether the supplied direction is valid.
  def valid_direction? direction
    DIRECTIONS.include? direction.to_sym
  end

  # This method executes the sequence of commands provided to the new() method.
  def execute_sequence
    raise CoolRobotError, "Invalid sequence." if @commands.nil?
    @commands.each do |cmd|
      matches = cmd.split(/(.+?)\s/)
      if matches.count > 1
        func, args = matches.drop(1)
      else
        func = matches.first
      end
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

      @history << cmd
    end
  end

  # Returns our x and y co-ordinates as well as currently-facing direction.
  def report
    [@position_x, @position_y, @direction]
  end

  # Checks that the next move is valid, and then moves there.
  def move
    if @table.within_bounds? *next_position
      @position_x = next_position[0]
      @position_y = next_position[1]
    else
      puts "Can't move, next position is out of bounds. Table: #{@table.bounds}"
    end
  end

  # Turns the robot left.
  def turn_left
    @direction = case @direction
      when 'EAST' then 'NORTH'
      when 'NORTH' then 'WEST'
      when 'WEST' then 'SOUTH'
      when 'SOUTH' then 'EAST'
    end
  end

  # Turns the robot right.
  def turn_right
    @direction = case @direction
      when 'EAST' then 'SOUTH'
      when 'NORTH' then 'EAST'
      when 'WEST' then 'NORTH'
      when 'SOUTH' then 'WEST'
    end
  end

  # Generates the next position based on the instance's current direction faced.
  def next_position
    next_pos = case @direction
      when 'NORTH' then [@position_x, @position_y + 1]
      when 'SOUTH' then [@position_x, @position_y - 1]
      when 'EAST'  then [@position_x + 1, @position_y]
      when 'WEST'  then [@position_x - 1, @position_y]
    end

    next_pos
  end

  # Outputs followed command history in a human-readable format.
  def display_history
    @history.join("\n")
  end

  # Clears followed command history.
  def clear_history
    @history = []
  end
end

# Nicer exception class name.
class CoolRobotError < StandardError; end
