class Contestant
  attr_accessor :spending_money
  attr_reader :first_name,
              :last_name,
              :age,
              :state_of_residence,
              :game_interests

  def initialize(data)
    @first_name = data[:first_name]
    @last_name = data[:last_name]
    @age = data[:age]
    @state_of_residence = data[:state_of_residence]
    @spending_money = data[:spending_money]
    @game_interests = []
  end

  def out_of_state?
    state_of_residence != 'CO'
  end
end
