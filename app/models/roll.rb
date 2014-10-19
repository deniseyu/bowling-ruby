class Roll

  attr_accessor :points

  def initialize(points = 0)
    @points = points
  end

  def knock_down(pin)
    pin.fall!
    self.points += 1
  end

end