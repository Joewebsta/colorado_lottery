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
      @cash5 = Game.new('Cash 5', 1, true)
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
        expect(subject.can_register?(alex, @cash5)).to be true
      end
    end

    context 'when interested_and_18? is false' do
      it 'returns false' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 25, state_of_residence: 'CO', spending_money: 10 })
        expect(subject.can_register?(alex, @cash5)).to be false
      end
    end
  end

  describe '#register_contestant' do
    before do
      @mega_millions = Game.new('Mega Millions', 5)
      @cash5 = Game.new('Cash 5', 1, true)
      @alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 28, state_of_residence: 'CO', spending_money: 10 })
    end

    context 'when #can_register? is true' do
      it 'updates @registered_contestants hash' do
        ben = Contestant.new({ first_name: 'Benjamin', last_name: 'Franklin', age: 20, state_of_residence: 'CO', spending_money: 100 })
        joe = Contestant.new({ first_name: 'Joe', last_name: 'Webster', age: 32, state_of_residence: 'CO', spending_money: 10 })

        @alex.add_game_interest('Mega Millions')
        joe.add_game_interest('Mega Millions')
        ben.add_game_interest('Cash 5')

        subject.register_contestant(@alex, @mega_millions)
        subject.register_contestant(joe, @mega_millions)
        subject.register_contestant(ben, @cash5)

        hash = { 'Mega Millions' => [@alex, joe], 'Cash 5' => [ben] }

        expect(subject.registered_contestants).to eql(hash)
      end
    end

    context 'when #can_register? is false' do
      it 'does not update @registered_contestants hash' do
        joe = Contestant.new({ first_name: 'Joe', last_name: 'Webster', age: 32, state_of_residence: 'MA', spending_money: 10 })
        joe.add_game_interest('Mega Millions')

        subject.register_contestant(@alex, @mega_millions)
        subject.register_contestant(joe, @mega_millions)

        expect(subject.registered_contestants).to eql({})
      end
    end
  end

  describe '#eligible_contestants' do
    before do
      @mega_millions = Game.new('Mega Millions', 5)
    end

    context 'when registered contestant has enough money' do
      it 'returns array of eligible contestant' do
        alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 28, state_of_residence: 'CO', spending_money: 10 })
        alex.add_game_interest('Mega Millions')
        subject.register_contestant(alex, @mega_millions)

        expect(subject.eligible_contestants(@mega_millions)).to eql([alex])
      end
    end

    context 'when registered contestant does not have enough money' do
      it 'does not return array of contestant ' do
        joe = Contestant.new({ first_name: 'Joe', last_name: 'Webster', age: 32, state_of_residence: 'MA', spending_money: 4 })
        joe.add_game_interest('Mega Millions')
        subject.register_contestant(joe, @mega_millions)

        expect(subject.eligible_contestants(@mega_millions)).to eql([])
      end
    end
  end

  describe '#charge_contestants' do
    before do
      @mega_millions = Game.new('Mega Millions', 5)
      @joe = Contestant.new({ first_name: 'Joe', last_name: 'Webster', age: 32, state_of_residence: 'CO', spending_money: 10 })
      @joe.add_game_interest('Mega Millions')
      subject.register_contestant(@joe, @mega_millions)
      subject.charge_contestants(@mega_millions)
    end

    it 'charges eligible contestants' do
      expect(@joe.spending_money).to eql 5
    end

    it 'updates current_contestants hash' do
      expect(subject.current_contestants).to eql({ @mega_millions => [@joe.full_name] })
    end
  end

  describe '#draw_winners' do
    before do
      @mega_millions = Game.new('Mega Millions', 5)
      @cash5 = Game.new('Cash 5', 1, true)
      @alex = Contestant.new({ first_name: 'Alexander', last_name: 'Aigades', age: 28, state_of_residence: 'CO', spending_money: 10 })
      @joe = Contestant.new({ first_name: 'Joe', last_name: 'Webster', age: 32, state_of_residence: 'CO', spending_money: 100 })
      @joe.add_game_interest('Mega Millions')
      @joe.add_game_interest('Cash 5')
      @alex.add_game_interest('Mega Millions')
      subject.register_contestant(@joe, @mega_millions)
      subject.register_contestant(@joe, @cash5)
      subject.register_contestant(@alex, @mega_millions)
      subject.charge_contestants(@mega_millions)
      subject.charge_contestants(@cash5)
      @drawing_date = subject.draw_winners
    end

    it 'returns the date of the drawing' do
      date_format = Time.now.strftime('%Y-%m-%d')
      expect(@drawing_date).to eql(date_format)
    end

    it 'updates the winners array' do
      expect(subject.winners.count).to eql(subject.current_contestants.count)
    end

    it 'updates an instance of Array' do
      expect(subject.winners).to be_an_instance_of Array
    end

    it 'populates the winners array with hashes' do
      expect(subject.winners.first.class).to eql Hash
      expect(subject.winners.last.class).to eql Hash
    end
  end
end
