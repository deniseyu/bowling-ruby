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

  def strike_points_frame(n)
    @frames[n].points_this_frame + 10
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