require './app/models/roll.rb'

describe Roll do 

  let(:pin) { double Pin }
  let(:roll) { Roll.new }

  it "can knock down a pin" do 
    expect(pin).to receive(:fall!)
    roll.knock_down(pin)
    allow(pin).to receive(:upright).and_return (false)
    expect(pin.upright).to be false
  end

  it "should produce one point for each pin knocked down" do
    allow(pin).to receive(:fall!)
    roll.knock_down(pin)
    expect(roll.points).to eq 1
  end

end