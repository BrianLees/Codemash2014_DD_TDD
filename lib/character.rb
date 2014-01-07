class Character

  attr_accessor :name, :hit_points
  attr_reader   :alignment, :armor_class, :strength, :dexterity, :constitution, :wisdom, :intelligence, :charisma

  ALIGNMENT = %w(Good Evil Neutral)
  ABILITY_SCORE = %w{1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20}

  def initialize(name='brian')
    @name = name
    @alignment = 'neutral'
    @armor_class = 10
    @hit_points = 5
    @strength = 10
    @dexterity = 10
    @constitution = 10
    @wisdom = 10
    @intelligence = 10
    @charisma = 10
  end

  def alignment=(alignment)
    unless ALIGNMENT.include? alignment
      raise 'Wrong alignment dude'
    end
    @alignment = alignment

  end

  def attack(defender, roll)
    if defender.hit?(roll)
      defender.critical_hit?(roll) ? defender.hit_points -= 2 : defender.hit_points -= 1
    end
  end

  def hit?(roll)
    roll >= @armor_class
  end

  def critical_hit?(roll)
    roll == 20
  end

  def set_ability(ability, value)
    raise 'Value of ability score not allowed' if value <1 || value > 20
    instance_variable_set("@#{ability}".to_sym, value)
  end

  def get_modifier(score)
    case score
      when 1 then -5
      when 2,3 then -4
      when 4,5 then -3
      when 6,7 then -2
      when 8,9 then -1
      when 10,11 then 0
      when 12,13 then 1
      when 14,15 then 2
      when 16,17 then 3
      when 18,19 then 4
      when 20 then 5
    end
  end

  def get_attack_roll(roll)
    roll + get_modifier(@strength)
  end

  def dead?
    @hit_points <= 0
  end

end