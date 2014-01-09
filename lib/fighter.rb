class Fighter < Character
  def get_attack_roll(roll)
    super(roll) - (@level / 2) + (@level - 1)
  end

  def calculate_hit_points
    super + (5 * @level)
  end
end