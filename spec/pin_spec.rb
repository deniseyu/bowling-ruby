require './app/models/pin.rb'

describe Pin do 

  let(:pin) { Pin.new }

  it "should initially be upright" do 
    expect(pin.upright).to be true
  end

  it "can fall down" do
    pin.fall!
    expect(pin.upright).to be false 
  end

end