class WarMonk < Character
  def initialize
    super
    @base_damage = 3
  end

  def calculate_hit_points
    super + (1 * @level)
  end

  def set_ability(ability, value)
    super
    @armor_class = calculate_armor_class if ability == 'wisdom'
  end

  def calculate_armor_class
    armor = super
    if get_modifier('wisdom') > 0
      armor += get_modifier('wisdom')
    end
    armor
  end

  def get_attack_roll(roll)
    roll = super(roll) - (@level / 2)

    level_mod = 0
    1.upto(@level) do |level|
      if level % 3 == 0
        level_mod += 1
      elsif level % 2 == 0
        level_mod += 1
      end
    end

    roll + level_mod
  end
end
