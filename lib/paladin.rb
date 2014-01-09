class Paladin < Character

  def calculate_hit_points
    super + (3 * @level)
  end

  def get_attack_roll(roll)
    roll = super(roll) - (@level / 2) + (@level - 1)
    roll += 2 if @attack_target.alignment == 'Evil'
    roll
  end

  def get_damage(roll)
    damage = @attack_target.alignment == 'Evil' ? @base_damage + 2 : @base_damage
    crit_modifier = @attack_target.alignment == 'Evil' ? 3 : 2
    super(roll, damage, crit_modifier)
  end
end