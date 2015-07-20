class Table
  def initialize x_bound, y_bound
    @x = x_bound
    @y = y_bound
  end

  def within_bounds? x, y
    return false if x < 0
    return false if y < 0
    return false if x > @x
    return false if y > @y

    true
  end
end
