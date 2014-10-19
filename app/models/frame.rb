class Frame 

  attr_accessor :rolls

  def initialize(roll1 = Roll.new, roll2 = Roll.new)
    @rolls = [roll1, roll2]
  end

  def points_this_frame
    self.rolls[0].points + self.rolls[1].points
  end

  def strike
    true if self.rolls[0].points == 10
  end

  def spare
    true if self.points_this_frame == 10 && self.rolls[0].points != 10
  end

end

class TenthFrame < Frame

  def initialize(roll1 = Roll.new, roll2 = Roll.new)
    @rolls = [roll1, roll2]
    if two_strikes == true
      add_roll
    elsif self.spare == true
      add_roll
    end
  end

  def two_strikes
    true if self.rolls[0].points == 10 && self.rolls[1].points == 10
  end

  def add_roll(roll3 = Roll.new)
    @rolls << roll3
  end


end