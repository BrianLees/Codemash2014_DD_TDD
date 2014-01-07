class WarMonk < Character
  def initialize
    super
    @base_damage = 3
  end

  def calculate_hit_points
    (6 + get_modifier(@constitution)) * @level
  end

  def set_ability(ability, value)
     raise 'Value of ability score not allowed' if value <1 || value > 20
     instance_variable_set("@#{ability}".to_sym, value)
     if ability == 'constitution'
       @current_hit_points = calculate_hit_points
     elsif ability == 'dexterity' || ability == 'wisdom'
       @armor_class = calculate_armor_class
     end
  end

  def calculate_armor_class
    armor = @default_armor_class + get_modifier(@dexterity)
    if get_modifier(@wisdom) > 0
      armor += get_modifier(@wisdom)
    end
    return armor
  end

  def get_attack_roll(roll)
    level_mod = 0
    1.upto(@level) do |level|
      if level % 3 == 0
        level_mod += 1
      elsif level % 2 == 0
        level_mod += 1
      end
    end

    roll + get_modifier(@strength) + level_mod
  end
end
