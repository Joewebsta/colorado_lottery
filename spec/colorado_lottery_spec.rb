require './lib/game'
require './lib/contestant'
require './lib/colorado_lottery'

describe ColoradoLottery do
  subject { ColoradoLottery.new }

  describe '#init' do
    it 'is an instance of ColoradoLottery' do
      is_expected.to be_an_instance_of ColoradoLottery
    end

    it 'has no registered contestants' do
      expect(subject.registered_contestants).to eql({})
    end

    it 'has no winners' do
      expect(subject.winners).to eql([])
    end

    it 'has no current contestants' do
      expect(subject.current_contestants).to eql({})
    end
  end
end
