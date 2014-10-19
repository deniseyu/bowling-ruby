class Game

  attr_accessor :frames

  def initialize
    @frames = []
  end

  def set_up_frames
    9.times { @frames << Frame.new }
    @frames << TenthFrame.new
  end

  def points_in_frame(n)
    @frames[n-1].points_this_frame
  end

  def strike_in_frame(n)
    @frames[n-1].strike 
  end

  def spare_in_frame(n)
    @frames[n-1].spare 
  end

  def later_frame(this_frame, frames_in_between)
    @frames[this_frame - 1 + frames_in_between]
  end

  def strike_points_frame(n)
    if later_frame(n, 1).strike != true 
      later_frame(n, 1).points_this_frame + 10
    elsif later_frame(n, 1).strike == true && later_frame(n, 2).strike != true
      later_frame(n, 2).points_this_frame + 20
    elsif later_frame(n, 2).strike == true
      return 30 
    end
  end

  def running_total
    @total_points = []
    @frames.to_enum.with_index.each do |frame, i|
      if strike_in_frame(i) 
        @total_points << strike_points_frame(i)
      else
        @total_points << points_in_frame(i)
      end
    end
    return @total_points.inject{ |a, b| a + b }
  end
    

end