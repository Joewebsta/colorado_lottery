require './lib/contestant'

describe Contestant do
  subject do
    Contestant.new({ first_name: 'Joe', last_name: 'Webster', age: 32, state_of_residence: 'CO', spending_money: 10 })
  end

  describe '#init' do
    it 'is an instance of Game' do
      is_expected.to be_an_instance_of Contestant
    end

    it 'has a first name' do
      expect(subject.first_name).to eql 'Joe'
    end

    it 'has a last name' do
      expect(subject.last_name).to eql 'Webster'
    end

    it 'has an age' do
      expect(subject.age).to eql 32
    end

    it 'has a state of residency' do
      expect(subject.state_of_residence).to eql 'CO'
    end

    it 'has spending money' do
      expect(subject.spending_money).to eql 10
    end

    it 'has no game interests' do
      expect(subject.game_interests).to eql([])
    end
  end
end
