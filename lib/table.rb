# This class contains table bounds and checking.
class Table
  # A good example would be "Table.new 5, 5" as this conforms to the test.
  def initialize x_bound, y_bound
    @x = x_bound
    @y = y_bound
  end

  # Return table bounds.
  def bounds
    "#{@x}, #{@y}"
  end

  # Does a bounds check on args passed in.
  def within_bounds? x, y
    return false if x < 0
    return false if y < 0
    return false if x > @x - 1
    return false if y > @y - 1

    true
  end
end
