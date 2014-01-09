class Weapon
  attr_reader :weapon_base_damage, :bonus_attack, :bonus_damage, :bonus_crit_modifier

  def initialize(type)
    @bonus_attack = nil
    @bonus_damage = nil
    @bonus_crit_modifier = nil

    # {attacker_race: {defender_race}}

    case type
      when :longsword
        @weapon_base_damage = 5
      when :waraxe
        @weapon_base_damage = 6
        @bonus_attack = {'All' =>  {'Others' => 2}}
        @bonus_damage = {'All' => {'Others' => 2}}
        @bonus_crit_modifier = {'All' => 1}
      when :elven_longsword
        @weapon_base_damage = 5
        @bonus_attack = {'All' => {'Orc' => 2, 'Others' => 1}, 'Elf' => {'Orc' => 5, 'Others' => 2}}
        @bonus_damage = {'All' => {'Orc' => 2, 'Others' => 1}, 'Elf' => {'Orc' => 5, 'Others' => 2}}
    end
  end
end