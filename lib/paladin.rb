class Paladin < Character

  def calculate_hit_points
    (8 + get_modifier(@constitution)) * @level
  end

  def attack(defender, roll, damage)
    if defender.alignment == 'Evil'
      damage = switch_to_evil_calculations(roll)
      roll += 2
    end

    if defender.hit?(roll, self.class)
      defender.take_damage(damage)
      gain_experience
    end
  end

  private

  def switch_to_evil_calculations(roll)
    @crit_modifier = 3
    @base_damage += 2
    damage = get_damage(roll)
    @crit_modifier = 2
    @base_damage -= 2
    damage
  end
end