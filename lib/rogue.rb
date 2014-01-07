class Rogue < Character
  def initialize
    super
    @crit_modifier = 3
    @attack_damage_modifier = 'dexterity'
  end
end