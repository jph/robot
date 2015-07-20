class Table
  def initialize x_bound, y_bound
    @x = x_bound
    @y = y_bound
  end

  def bounds
    "#{@x}, #{@y}"
  end

  def within_bounds? x, y
    return false if x < 0
    return false if y < 0
    return false if x > @x - 1
    return false if y > @y - 1

    true
  end
end
