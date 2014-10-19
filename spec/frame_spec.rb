require './app/models/frame.rb'

describe Frame do 

  let(:roll_one) { double Roll }
  let(:roll_two) { double Roll }
  let(:frame) { Frame.new(roll_one, roll_two) }

  it "should contain two rolls by default" do 
    expect(frame.rolls.count).to eq 2
  end

  context "In the absence of strikes or spares" do 

    it "should award one point per pin knocked down" do 
      allow(roll_one).to receive(:points).and_return(5)
      allow(roll_two).to receive(:points).and_return(3)
      expect(frame.points_this_frame).to eq 8
    end

  end

  context "In the event of a strike" do 

    it "should log a strike" do 
      allow(roll_one).to receive(:points).and_return(10)
      allow(roll_two).to receive(:points).and_return(0)
      expect(frame.strike).to be(true)
    end

    it "should not confuse a spare with a strike" do 
      allow(roll_one).to receive(:points).and_return (5)
      allow(roll_two).to receive(:points).and_return (5)
      expect(frame.strike).not_to be(true)
    end

  end

  context "In the event of a spare" do 

    it "should log a spare" do 
      allow(roll_one).to receive(:points).and_return(6)
      allow(roll_two).to receive(:points).and_return(4)
      expect(frame.spare).to be(true)
    end

    it "should not confuse a strike with a spare" do 
      allow(roll_one).to receive(:points).and_return(10)
      allow(roll_two).to receive(:points).and_return(0)
      expect(frame.spare).not_to be(true)
    end

  end

  context "Extra roll in the tenth frame" do 

    let(:tenth_frame) { TenthFrame.new(roll_one, roll_two) }
    let(:roll_three) { double Roll }

    it "should occur in the event of two consecutive strike" do 
      allow(roll_one).to receive(:points).and_return(10)
      allow(roll_two).to receive(:points).and_return(10)
      expect(tenth_frame.two_strikes).to be true
      expect(tenth_frame.rolls.count).to eq 3
    end 

    it "should occur in the event of a spare" do 
      allow(roll_one).to receive(:points).and_return(7)
      allow(roll_two).to receive(:points).and_return(3)
      expect(tenth_frame.spare).to be(true)
      expect(tenth_frame.rolls.count).to eq 3
    end 

    it "should not occur in the absence of a strike or spare" do 
      allow(roll_one).to receive(:points).and_return(3)
      allow(roll_two).to receive(:points).and_return(4)
      expect(tenth_frame.rolls.count).to eq 2
    end

    it "should not occur if there is only one strike" do 
      allow(roll_one).to receive(:points).and_return(10)
      allow(roll_two).to receive(:points).and_return(5)
      expect(tenth_frame.strike).to be(true)
      expect(tenth_frame.two_strikes).not_to be(true)
      expect(tenth_frame.rolls.count).to eq 2
    end

  end

end