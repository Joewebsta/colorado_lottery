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
    interested_and_18?(contestant, game) &&
      (!contestant.out_of_state? || game.national_drawing?)
  end

  def register_contestant(contestant, game)
    return unless can_register?(contestant, game)

    if registered_contestants[game.name].nil?
      registered_contestants[game.name] = [contestant]
    else
      registered_contestants[game.name] << contestant
    end
  end

  def eligible_contestants(game)
    return [] if registered_contestants.empty?

    registered_contestants[game.name].find_all do |contestant|
      contestant.spending_money > game.cost
    end
  end

  def charge_contestants(game)
    contestants = eligible_contestants(game)
    contestant_names = contestants.map do |contestant|
      contestant.spending_money -= game.cost
      contestant.full_name
    end

    current_contestants[game] = contestant_names
  end

  def draw_winners
    current_contestants.each do |game, contestants|
      winner_name = contestants.sample
      winners << { winner_name => game.name }
    end

    Time.now.strftime('%Y-%m-%d')
  end

  def announce_winner(game_name)
    date = draw_winners
    formatted_date = date[5, 9]
    winner_hash = winners.find { |name_game_hash| name_game_hash.values.include?(game_name) }
    winner_name = winner_hash.key(game_name)

    "#{winner_name} won the #{game_name} on #{formatted_date}."
  end
end
