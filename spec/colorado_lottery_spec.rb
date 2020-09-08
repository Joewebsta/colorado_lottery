require './lib/game'
require './lib/contestant'
require './lib/colorado_lottery'

describe ColoradoLottery do
  subject { ColoradoLottery.new }

  # let(:alexander) { Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 28, state_of_residence: 'CO', spending_money: 10 }) }
  # let(:benjamin) { Contestant.new({ first_name: 'Benjamin', last_name: 'Franklin', age: 17, state_of_residence: 'PA', spending_money: 100 }) }
  # let(:frederick) { Contestant.new({ first_name: 'Frederick', last_name: 'Douglas', age: 55, state_of_residence: 'NY', spending_money: 20 }) }
  # let(:winston) { Contestant.new({ first_name: 'Winston', last_name: 'Churchill', age: 18, state_of_residence: 'CO', spending_money: 5 }) }

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

  describe '#interested_and_18?' do
    before { @mega_millions = Game.new('Mega Millions', 5) }

    context 'when interested and 18' do
      it 'returns true' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 28, state_of_residence: 'CO', spending_money: 10 })
        alex.add_game_interest('Mega Millions')
        expect(subject.interested_and_18?(alex, @mega_millions)).to be true
      end
    end

    context 'when not interested and 18' do
      it 'returns false' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 28, state_of_residence: 'CO', spending_money: 10 })
        expect(subject.interested_and_18?(alex, @mega_millions)).to be false
      end
    end

    context 'when interested and not 18' do
      it 'returns false' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 15, state_of_residence: 'CO', spending_money: 10 })
        alex.add_game_interest('Mega Millions')
        expect(subject.interested_and_18?(alex, @mega_millions)).to be false
      end
    end

    context 'when not interested and not 18' do
      it 'returns false' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 15, state_of_residence: 'CO', spending_money: 10 })
        expect(subject.interested_and_18?(alex, @mega_millions)).to be false
      end
    end
  end

  describe '#can_register?' do
    before do
      @mega_millions = Game.new('Mega Millions', 5)
      @cash_5 = Game.new('Cash 5', 1, true)
    end

    context 'when interested_and_18? is true and CO resident' do
      it 'returns true' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 25, state_of_residence: 'CO', spending_money: 10 })
        alex.add_game_interest('Mega Millions')
        expect(subject.can_register?(alex, @mega_millions)).to be true
      end
    end

    context 'when interested_and_18? is true and national game' do
      it 'returns true' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 25, state_of_residence: 'MA', spending_money: 10 })
        alex.add_game_interest('Cash 5')
        expect(subject.can_register?(alex, @cash_5)).to be true
      end
    end

    context 'when interested_and_18? is false' do
      it 'returns false' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 25, state_of_residence: 'CO', spending_money: 10 })
        expect(subject.can_register?(alex, @cash_5)).to be false
      end
    end
  end
end
