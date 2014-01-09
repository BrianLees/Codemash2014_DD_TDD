class Character

  attr_accessor :name, :attack_target
  attr_reader   :alignment, :armor_class, :current_hit_points, :strength, :dexterity, :constitution, :wisdom, :intelligence, :charisma, :experience_points, :level, :max_hit_points, :race, :weapon

  ALIGNMENT = %w(Good Evil Neutral)

  def initialize(race = 'Human')
    @name = 'Nameless'
    @race = Object.const_get(race).new
    @base_damage = 1
    @alignment = 'neutral'
    @strength = 10
    @dexterity = 10
    @constitution = 10
    @wisdom = 10
    @intelligence = 10
    @charisma = 10
    @experience_points = 0
    @level = 1
    @max_hit_points = calculate_hit_points
    @current_hit_points = @max_hit_points
    @default_armor_class = determine_default_armor_class
    @armor_class = calculate_armor_class
    @crit_modifier = 2
    @attack_damage_modifier = 'strength'
    @attack_target = self
    @critical_threshold = 20
  end

  def alignment=(alignment)
    unless ALIGNMENT.include? alignment
      raise 'Wrong alignment dude'
    end
    @alignment = alignment

  end

  def attack(roll, damage)
    defender = @attack_target
    if defender.hit?(roll, self)
      defender.take_damage(damage)
      gain_experience
    end
  end

  def take_damage (damage)
    @current_hit_points -= damage
  end

  def hit?(roll, attacker)
    if attacker.class == Rogue && get_modifier('dexterity') > 0
      roll_armor_check = @default_armor_class
    else
      roll_armor_check = @armor_class
    end
    if attacker.race.class == Orc && @race.class == Elf
      roll_armor_check += 2
    end
    if @race.class == Halfling && attacker.race.class != Halfling
      roll_armor_check += 2
    end
    roll >= roll_armor_check
  end

  def critical_hit?(roll)
    @critical_threshold -= 1 if @race.class == Elf
    roll >= @critical_threshold
  end

  def set_ability(ability, value)
    raise 'Value of ability score not allowed' if value < 1 || value > 20
    instance_variable_set("@#{ability}".to_sym, value)
    if ability == 'constitution'
      @current_hit_points = calculate_hit_points
    elsif ability == 'dexterity'
      @armor_class = calculate_armor_class
    end
  end

  def get_modifier(ability)
    score = instance_variable_get("@#{ability}".to_sym)
    modifier = (score - 10) / 2
    modifier + apply_race_modifier(ability)
  end

  def apply_race_modifier(ability)
    @race.ability_modifiers[ability.to_sym]
  end

  def get_attack_roll(roll)
    weapon_attack_roll_bonus = 0

    if @weapon
      weapon_attack_roll_bonus = @weapon.bonus_attack[:all][:others] unless @weapon.bonus_attack.nil?
    end

    if @race.class == Dwarf && @attack_target.race.class == Orc
      roll += 2
    end
    roll + weapon_attack_roll_bonus + get_modifier('strength') + @level / 2
  end

  def get_damage(roll, base_damage = @base_damage, crit_modifier = @crit_modifier)
    weapon_bonus_damage = 0

    if @weapon
      base_damage += @weapon.weapon_base_damage
      weapon_bonus_damage = get_weapon_damage
      crit_modifier += @weapon.bonus_crit_modifier[:all] if @weapon.bonus_crit_modifier
    end

    damage = (@race.class == Dwarf && @attack_target.race.class == Orc) ? base_damage + 2 : base_damage

    if critical_hit?(roll)
      damage = (damage + (get_modifier(@attack_damage_modifier) * 2)) * crit_modifier
    else
      damage += get_modifier(@attack_damage_modifier)
    end

    damage += weapon_bonus_damage
    damage < 1 ? 1 : damage
  end

  def calculate_armor_class
    @default_armor_class + get_modifier('dexterity')
  end

  def calculate_hit_points
    constitution_bonus = get_modifier('constitution')
    racial_bonus = (@race.class == Dwarf && constitution_bonus > 0) ? 2 : 1
    (5 + (constitution_bonus * racial_bonus)) * @level
  end

  def dead?
    @current_hit_points <= 0
  end

  def equip_weapon(weapon)
    @weapon = weapon
  end

  private
  def gain_experience
    @experience_points += 10
    level_up if @experience_points == (@level * 1000)
  end

  def level_up
    @level += 1
    @max_hit_points = calculate_hit_points
  end

  def determine_default_armor_class
    @race.class == Orc ? 12 : 10
  end

  def get_weapon_damage
    return 0 unless @weapon.bonus_damage
    if @weapon.bonus_damage[@race.class.to_s]
      weapon_stats = @weapon.bonus_damage[@race.class.to_s]
    else
      weapon_stats = @weapon.bonus_damage['All']
    end

    if weapon_stats[@attack_target.race.class.to_s]
      weapon_stats = weapon_stats[@attack_target.race.class.to_s]
    else
      weapon_stats = weapon_stats['Others']
    end
    weapon_stats
  end
end