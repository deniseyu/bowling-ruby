class Pin

  attr_accessor :upright

  def initialize
    @upright = true 
  end

  def fall!
    @upright = false 
  end

end