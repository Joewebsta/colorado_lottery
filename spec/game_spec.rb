require './lib/game'

describe Game do
  subject { Game.new('Pick 4', 2) }

  describe '#init' do
    it 'is an instance of Game' do
      is_expected.to be_an_instance_of Game
    end

    it 'has a name' do
      expect(subject.name).to eql 'Pick 4'
    end

    it 'has a cost' do
      expect(subject.cost).to eql 2
    end

    it 'is not a national drawing' do
      expect(subject.national_drawing).to be false
    end
  end

  context 'when national_drawing argument not provided' do
    it 'returns false' do
      expect(subject.national_drawing?).to be false
    end
  end

  context 'when national_drawing argument provided' do
    it 'returns true' do
      game = Game.new('Pick 4', 2, true)
      expect(game.national_drawing?).to be true
    end
  end
end
