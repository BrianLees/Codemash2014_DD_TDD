class Paladin < Character

  def calculate_hit_points
    (8 + get_modifier(@constitution)) * @level
  end

  def get_attack_roll(roll)
    roll = roll + get_modifier(@strength) + @level - 1
    roll += 2 if @attack_target.alignment == 'Evil'
    roll
  end

  def get_damage(roll)
    modifier = instance_variable_get("@#{@attack_damage_modifier}".to_sym)
    damage = @attack_target.alignment == 'Evil' ? @base_damage + 2 : @base_damage
    if critical_hit?(roll)
      crit_modifier = @attack_target.alignment == 'Evil' ? 3 : 2
      damage = (damage + (get_modifier(modifier) * 2)) * crit_modifier
    else
      damage += get_modifier(modifier)
    end

    damage < 1 ? 1 : damage
  end
end