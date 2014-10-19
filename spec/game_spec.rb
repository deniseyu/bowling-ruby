require './app/models/game.rb'

describe Game do 

  let(:game) { Game.new }
  let(:frame_one) { double Frame }
  let(:frame_two) { double Frame}
  let(:frame_three) { double Frame }
  let(:frame_four) { double Frame }
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

      def add_all_frames(game, *frames)
        frames.each { |frame| game.frames << frame }
      end

    context "Strikes" do 

      let(:frame_one) { double Frame, :spare => false }
      let(:frame_two) { double Frame, :spare => false }
      let(:frame_three) { double Frame, :spare => false }
      let(:frame_four) { double Frame, :spare => false }

      it "a frame containing a strike will be worth the subsequent open frame plus 10" do 
        allow(frame_one).to receive(:strike).and_return(true)
        allow(frame_two).to receive(:points_this_frame).and_return(5)
        allow(frame_two).to receive(:strike).and_return(false)
        add_all_frames(game, frame_one, frame_two)
        expect(game.strike_points_frame(1)).to eq(15)
        expect(game.points_in_frame(2)).to eq(5)
        expect(game.running_total).to eq(20)
      end

      it "a strike followed by another strike will be worth the next open frame plus 20" do 
        allow(frame_one).to receive(:strike).and_return(true)
        allow(frame_two).to receive(:strike).and_return(true)
        allow(frame_three).to receive(:strike).and_return(false)
        allow(frame_three).to receive(:points_this_frame).and_return(5)
        add_all_frames(game, frame_one, frame_two, frame_three)
        expect(game.strike_points_frame(1)).to eq(25)
        expect(game.strike_points_frame(2)).to eq(15)
        expect(game.points_in_frame(3)).to eq(5)
        expect(game.running_total).to eq(45)
      end

      it "a strike followed by two more strikes will be max out at 30 points" do 
        allow(frame_one).to receive(:strike).and_return(true)
        allow(frame_two).to receive(:strike).and_return(true)
        allow(frame_three).to receive(:strike).and_return(true)
        allow(frame_four).to receive(:strike).and_return(false)
        allow(frame_four).to receive(:points_this_frame).and_return(5)
        add_all_frames(game, frame_one, frame_two, frame_three, frame_four)
        expect(game.strike_points_frame(1)).to eq(30)
        expect(game.strike_points_frame(2)).to eq(25)
        expect(game.strike_points_frame(3)).to eq(15)
        expect(game.points_in_frame(4)).to eq(5)
        expect(game.running_total).to eq(75)
      end

      it "sanity check to ensure that five consecutive strikes will work" do
        frame_four = double :Frame, :spare => false
        frame_five = double :Frame, :spare => false
        frame_six = double :Frame, :spare => false
        allow(frame_one).to receive(:strike).and_return(true)
        allow(frame_two).to receive(:strike).and_return(true)
        allow(frame_three).to receive(:strike).and_return(true)
        allow(frame_four).to receive(:strike).and_return(true)
        allow(frame_five).to receive(:strike).and_return(true)
        allow(frame_six).to receive(:strike).and_return(false)
        allow(frame_six).to receive(:points_this_frame).and_return(7)
        add_all_frames(game, frame_one, frame_two, frame_three, frame_four, frame_five, frame_six)
        expect(game.running_total).to eq(141) # yay it works!
      end 

    end

    context "Spares" do 

      let(:frame_one) { double Frame, :strike => false }
      let(:frame_two) { double Frame, :strike => false }
      let(:frame_three) { double Frame, :strike => false }
      let(:frame_four) { double Frame, :strike => false }

      it "a spare followed by an open frame will be worth 
      the first roll of the subsequent frame + 10" do
        allow(frame_one).to receive(:spare).and_return(true)
        allow(frame_two).to receive(:spare).and_return(false)
        allow(frame_two).to receive(:first_roll).and_return(4)
        allow(frame_two).to receive(:second_roll).and_return(3)
        allow(frame_two).to receive(:points_this_frame).and_return(7)
        add_all_frames(game, frame_one, frame_two)
        expect(game.spare_points_frame(1)).to eq(14)
        expect(game.points_in_frame(2)).to eq(7)
        expect(game.running_total).to eq(21)
      end

      it "a spare followed by another spare will be worth the first roll of the next spare" do 
        allow(frame_one).to receive(:spare).and_return(true)
        allow(frame_two).to receive(:spare).and_return(true)
        allow(frame_two).to receive(:first_roll).and_return(7)
        allow(frame_two).to receive(:second_roll).and_return(3)
        allow(frame_three).to receive(:spare).and_return(false)
        allow(frame_three).to receive(:first_roll).and_return(3)
        allow(frame_three).to receive(:points_this_frame).and_return(5)
        add_all_frames(game, frame_one, frame_two, frame_three)
        expect(game.spare_points_frame(1)).to eq(17)
        expect(game.spare_points_frame(2)).to eq(13)
        expect(game.points_in_frame(3)).to eq(5)
        expect(game.running_total).to eq(35)
      end

    end

    context "All together now" do 

      let(:strike_frame) { double Frame, :strike => true, :spare => false }
      let(:spare_frame) { double Frame, :strike => false, :spare => true }
      let(:open_frame) { double Frame, :strike => false, :spare => false }

      it "strike, spare, open" do 
        allow(spare_frame).to receive(:points_this_frame).and_return(10)
        allow(open_frame).to receive(:first_roll).and_return(3)
        allow(open_frame).to receive(:points_this_frame).and_return(6)
        add_all_frames(game, strike_frame, spare_frame, open_frame)
        expect(game.strike_points_frame(1)).to eq(20)
        expect(game.spare_points_frame(2)).to eq(13)
        expect(game.points_in_frame(3)).to eq(6)
        expect(game.running_total).to eq(39)
      end

      it "spare, strike, open" do 
        allow(spare_frame).to receive(:points_this_frame).and_return(10)
        allow(strike_frame).to receive(:first_roll).and_return(10)
        allow(open_frame).to receive(:points_this_frame).and_return(4)
        add_all_frames(game, spare_frame, strike_frame, open_frame)
        expect(game.spare_points_frame(1)).to eq(20)
        expect(game.strike_points_frame(2)).to eq(14)
        expect(game.points_in_frame(3)).to eq(4)
        expect(game.running_total).to eq(38)
      end

    end

  end

end