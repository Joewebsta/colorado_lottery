class ColoradoLottery
  attr_reader :registered_contestants, :current_contestants, :winners

  def initialize
    @registered_contestants = {}
    @current_contestants = {}
    @winners = []
  end

  def interested_and_18?(contestant, game)
    contestant.age >= 18 && contestant.game_interests.include?(game.name)
  end

  def can_register?(contestant, game)
    interested_and_18?(contestant, game) && (!contestant.out_of_state? || game.national_drawing?)
  end

  def register_contestant(contestant, game)
    return unless can_register?(contestant, game)

    if registered_contestants[game.name]
      registered_contestants[game.name] << contestant
    else
      registered_contestants[game.name] = [contestant]
    end
  end

  def eligible_contestants(game)
    return [] if registered_contestants.empty?

    registered_contestants[game.name].find_all { |contestant| contestant.spending_money > game.cost }
  end

  def charge_contestants(game)
    eligible_contestants(game).each do |contestant|
      contestant.spending_money -= game.cost

      if current_contestants[game]
        current_contestants[game] << contestant.full_name
      else
        current_contestants[game] = [contestant.full_name]
      end
    end
  end

  def draw_winners
    current_contestants.each do |game, contestants|
      winner_name = contestants.sample
      winners << { winner_name => game.name }
    end

    Time.now.strftime('%Y-%m-%d')
  end
end
