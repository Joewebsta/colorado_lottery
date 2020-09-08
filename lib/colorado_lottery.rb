class ColoradoLottery
  attr_reader :registered_contestants, :winners, :current_contestants

  def initialize
    @registered_contestants = {}
    @winners = []
    @current_contestants = {}
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
end
