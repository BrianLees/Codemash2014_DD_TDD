class Rogue < Character
  def initialize(race = 'Human')
    super(race)
    @crit_modifier += 1
    @attack_damage_modifier = 'dexterity'
  end
end