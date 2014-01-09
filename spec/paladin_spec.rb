require_relative 'spec_helper'

describe 'Paladin' do
  let(:paladin){Paladin.new}
  let(:defender){Character.new}
  let(:evil_defender) do
    d = Character.new
    d.alignment = 'Evil'
    d
  end

  it 'can create a paladin' do
    Paladin.new.should_not be_nil
  end

  context 'it has 6 hit points per level' do
    it 'level is 1' do
      paladin.max_hit_points.should == 8
    end
  end

  context 'it has attack and damage modifiers against evil characters' do
    let(:paladin_vs_evil) do
      p = Paladin.new
      p.attack_target = evil_defender
      p
    end

    it 'add 2 to attack roll against evil characters' do
      roll = 9
      attack_roll = paladin_vs_evil.get_attack_roll(roll)
      damage = paladin_vs_evil.get_damage(roll)
      paladin_vs_evil.attack(attack_roll, damage)
      evil_defender.current_hit_points.should < evil_defender.max_hit_points
    end

    it 'add 2 to damage against an evil character' do
      roll = 10
      attack_roll = paladin_vs_evil.get_attack_roll(roll)
      damage = paladin_vs_evil.get_damage(roll)
      paladin_vs_evil.attack(attack_roll, damage)
      evil_defender.current_hit_points.should == 2
    end

    it 'crits do triple damage against evil characters' do
      roll = 20
      attack_roll = paladin_vs_evil.get_attack_roll(roll)
      damage = paladin_vs_evil.get_damage(roll)
      paladin_vs_evil.attack(attack_roll, damage)
      evil_defender.current_hit_points.should == evil_defender.max_hit_points - ((1 + 2 ) * 3)
    end

    it 'crits do triple damage against evil, and strength modifiers' do
      roll = 20
      paladin_vs_evil.set_ability('strength', 20)
      attack_roll = paladin_vs_evil.get_attack_roll(roll)
      damage = paladin_vs_evil.get_damage(roll)
      paladin_vs_evil.attack(attack_roll, damage)
      evil_defender.current_hit_points.should == evil_defender.max_hit_points - ((1 + 2 + (5 * 2)) * 3)
    end
  end

  context 'attack roll is increased by 1 for every level' do
    it 'level is 1' do
      paladin.attack_target = defender
      paladin.get_attack_roll(18).should == 18
    end

    it 'complex scenario' do
      paladin.attack_target = defender
      4.times{paladin.send('level_up')}
      paladin.set_ability('strength', 15)
      paladin.get_attack_roll(13).should == 19
    end
  end

  context 'race and weapon integration' do
    it 'Elf paladin with an elven longsword with a +5 strength modifier critting an Evil, Orc Rogue' do
      pending
      paladin = Paladin.new('Elf')
      paladin.equip_weapon(Weapon.new(:elven_longsword))
      paladin.set_ability('strength', 20)

      rogue = Rogue.new('Orc')
      rogue.alignment = 'Evil'

      # 1 base + 2 vs evil + 5 str + 5 elven longsword + 5 elf vs orc * 3 for crit
      expected_life = rogue.current_hit_points - 54
      roll = 20
      paladin.attack_target = rogue
      paladin.attack(paladin.get_attack_roll(roll), paladin.get_damage(roll))
      rogue.current_hit_points.should == expected_life
    end
  end
end
