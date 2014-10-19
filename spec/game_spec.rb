require './app/models/game.rb'

describe Game do 

  let(:game) { Game.new }
  let(:frame_one) { double Frame }
  let(:frame_two) { double Frame}
  let(:frame_three) { double Frame }
  let(:roll_one) { double Roll }
  let(:roll_two) { double Roll }
  let(:player) { double Player }

  it "should be composed of ten frames" do 
    game.set_up_frames
    expect(game.frames.count).to eq 10 
  end

  it "should know how many points were scored in an open frame" do 
    game.frames.push(frame_one)
    allow(frame_one).to receive(:points_this_frame).and_return(9)
    expect(game.points_in_frame(1)).to eq 9
  end

  it "should know if a frame contains a strike" do 
    game.frames.push(frame_one)
    allow(frame_one).to receive(:strike).and_return(true)
    expect(game.strike_in_frame(1)).to eq true
  end

  it "should know if a frame contains a spare" do 
    game.frames.push(frame_one)
    allow(frame_one).to receive(:spare).and_return(true)
    expect(game.spare_in_frame(1)).to eq true
  end

  context "The scoring mechanism:" do 

    context "A frame that contains a strike" do 

      it "will be worth the subsequent open frame plus 10" do 
        allow(frame_one).to receive(:strike).and_return(true)
        allow(frame_two).to receive(:points_this_frame).and_return(5)
        allow(frame_two).to receive(:strike).and_return(false)
        game.frames.push(frame_one)
        game.frames.push(frame_two)
        expect(game.strike_points_frame(1)).to eq(15)
        expect(frame_two.points_this_frame).to eq(5)
        expect(game.running_total).to eq(20)
      end

    end

  end

end