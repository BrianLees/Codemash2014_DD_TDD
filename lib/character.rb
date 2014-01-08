class Character

  attr_accessor :name, :attack_target
  attr_reader   :alignment, :armor_class, :current_hit_points, :strength, :dexterity, :constitution, :wisdom, :intelligence, :charisma, :experience_points, :level, :max_hit_points

  ALIGNMENT = %w(Good Evil Neutral)
  ABILITY_SCORE = %w{1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20}

  def initialize(name='brian')
    @name = name
    @base_damage = 1
    @alignment = 'neutral'
    @strength = 10
    @dexterity = 10
    @constitution = 10
    @wisdom = 10
    @intelligence = 10
    @charisma = 10
    @experience_points = 0
    @level = 1
    @max_hit_points = calculate_hit_points
    @current_hit_points = @max_hit_points
    @default_armor_class = 10
    @armor_class = calculate_armor_class
    @crit_modifier = 2
    @attack_damage_modifier = 'strength'
  end

  def alignment=(alignment)
    unless ALIGNMENT.include? alignment
      raise 'Wrong alignment dude'
    end
    @alignment = alignment

  end

  def attack(defender, roll, damage)
    if defender.hit?(roll, self.class)
      defender.take_damage(damage)
      gain_experience
    end
  end

  def take_damage (damage)
    @current_hit_points -= damage
  end

  def hit?(roll, attacker_class)
    if attacker_class == Rogue && get_modifier(@dexterity) > 0
      roll >= @default_armor_class
    else
      roll >= @armor_class
    end
  end

  def critical_hit?(roll)
    roll == 20
  end

  def set_ability(ability, value)
    raise 'Value of ability score not allowed' if value <1 || value > 20
    instance_variable_set("@#{ability}".to_sym, value)
    if ability == 'constitution'
      @current_hit_points = calculate_hit_points
    elsif ability == 'dexterity'
      @armor_class = calculate_armor_class
    end
  end

  def get_modifier(score)
    (score - 10) / 2
  end

  def get_attack_roll(roll)
    roll + get_modifier(@strength) + @level / 2
  end

  def get_damage(roll)
    modifier = instance_variable_get("@#{@attack_damage_modifier}".to_sym)
    damage = @base_damage
    if critical_hit?(roll)
      damage = (damage + (get_modifier(modifier) * 2)) * @crit_modifier
    else
      damage += get_modifier(modifier)
    end

    damage < 1 ? 1 : damage
  end

  def calculate_armor_class
    @default_armor_class + get_modifier(@dexterity)
  end

  def calculate_hit_points
    (5 + get_modifier(@constitution)) * @level
  end

  def dead?
    @current_hit_points <= 0
  end

  private
  def gain_experience
    @experience_points += 10
    level_up if @experience_points == (@level * 1000)
  end

  def level_up
    @level += 1
    @max_hit_points = calculate_hit_points
  end
end