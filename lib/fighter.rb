class Fighter < Character
  def get_attack_roll(roll)
    roll + get_modifier(@strength) + @level - 1
  end

  def calculate_hit_points
    (10 + get_modifier(@constitution)) * @level
  end
end