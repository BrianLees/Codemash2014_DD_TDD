require_relative 'spec_helper'

describe 'Character' do
  let(:character){Character.new}
  let(:attacker){Character.new}
  let(:defender){Character.new}

  it 'will create a character' do
    Character.new.should_not be_nil
  end

  describe 'name' do
    it 'has a name' do
      c = Character.new('brian')
      c.name.should == 'brian'
    end

    it 'can change name' do
      name = character.name
      character.name = 'evan'
      character.name.should_not == name
      character.name.should == 'evan'
    end
  end

  describe 'alignment' do
    it 'has alignment' do
      character.alignment.should_not be_nil
    end

    it 'change the alignment' do
      character.alignment.should_not == 'Evil'
      character.alignment = 'Evil'
      character.alignment.should == 'Evil'
    end

    it 'must have an alignment of good evil or neutral' do
      lambda{character.alignment = :bob}.should raise_error
    end

    it 'can set the alignment to good, evil or neutral' do
      %w(Evil Good Neutral).each do |alignment|
        character.alignment = alignment
        character.alignment.should == alignment
      end
    end
  end

  describe 'armor class and hit points' do
    it 'armor class defaults to 10' do
      character.armor_class.should == 10
    end

    it 'hit points default to 5' do
      character.current_hit_points.should == 5
    end
  end

  describe 'can attack' do
    it 'if roll beats armor class, it is a hit' do
      roll = character.armor_class
      character.hit?(roll, character.class).should be_true
    end

    it 'if roll does not beat armor class, it is a miss' do
      roll = character.armor_class - 1
      character.hit?(roll, character.class).should be_false
    end
  end

  describe 'can be damaged' do
    it 'takes 1 point of damage when hit' do
      roll = character.armor_class
      hit_points = defender.current_hit_points
      attacker.attack(defender, roll, 1)
      defender.current_hit_points.should == hit_points - 1
    end

    it 'critical hit if roll is 20' do
      roll = 20
      character.critical_hit?(roll).should be_true
    end

    it 'critical hits do double damage' do
      roll = 20
      hit_points = defender.current_hit_points
      damage = attacker.get_damage(roll)
      attacker.attack(defender, roll, damage)
      defender.current_hit_points.should == hit_points - 2
    end

    it 'can kill a character with 0 or less hit points' do
      character.take_damage(character.current_hit_points)
      character.should be_dead
      character.take_damage(1)
      character.should be_dead
    end

    it 'a character with more than 0 hit points is not dead' do
      character.take_damage(character.current_hit_points - 1)
      character.should_not be_dead
    end
  end

  describe 'has ability scores' do
    it 'Strength, Dexterity, Constitution, Wisdom, Intelligence & Charisma default to 10' do
      %w(strength dexterity constitution wisdom intelligence charisma).each do |ability|
        character.send("#{ability}").should == 10
      end
    end

    it 'values can be 1 to 20' do
      1.upto(20).each do |count|
        character.set_ability('strength', count)
        character.strength.should == count
      end
    end

    it 'values cannot be outside the range of 1 to 20' do
      [0, 21].each do |value|
        lambda{character.set_ability('dexterity', value)}.should raise_error
      end
    end

    it 'has correct modifiers for ability scores' do
      1.upto(20).each do |score|
        character.get_modifier(score).should == -5  if score == 1
        character.get_modifier(score).should == -4 if [2,3].include?(score)
        character.get_modifier(score).should == -3 if [4,5].include?(score)
        character.get_modifier(score).should == -2 if [6,7].include?(score)
        character.get_modifier(score).should == -1 if [8,9].include?(score)
        character.get_modifier(score).should == 0 if [10,11].include?(score)
        character.get_modifier(score).should == 1 if [12,13].include?(score)
        character.get_modifier(score).should == 2 if [14,15].include?(score)
        character.get_modifier(score).should == 3 if [16,17].include?(score)
        character.get_modifier(score).should == 4 if [18,19].include?(score)
        character.get_modifier(score).should == 5 if score == 20
      end
    end
  end

  describe 'ability modifiers modify attributes' do
    describe 'strength modifier' do
      it 'is added to attack roll' do
        roll = 9
        attacker.set_ability('strength', 14)
        attacker.get_attack_roll(roll).should == 11
      end

      it 'is added to the damage dealt' do
        attacker.set_ability('strength', 16)
        attacker.get_damage(1).should == 4
      end

      it 'damage dealt is changed based on strength' do
        attacker.set_ability('strength', 14)
        die_roll = 9
        roll = attacker.get_attack_roll(die_roll)
        damage = attacker.get_damage(1)
        attacker.attack(defender, roll, damage)
        defender.current_hit_points.should == 2
      end

      it 'critical hit damage uses double strength modifier' do
        attacker.set_ability('strength', 16)
        die_roll = 20
        attacker.get_damage(die_roll).should == 14
      end

      it 'minimum damage is always 1 on hit' do
        character.set_ability('strength', 1)
        character.get_damage(15).should == 1
      end

    end

    describe 'dexterity_modifier' do
      it 'is added to armor class' do
        defender.set_ability('dexterity', 13)
        defender.armor_class.should == 11
      end
    end

    describe 'constitution modifier' do
      it 'is added to hit points' do
        character.set_ability('constitution', 20)
        character.current_hit_points.should == 10
      end
    end

    describe 'experience points gained' do
      it 'is 10 points after a successful attack' do
        experience_points = character.experience_points
        character.attack(defender, 20, 2)
        character.experience_points.should == experience_points + 10
      end

      it 'is 0 points after an unsuccessful attack' do
        experience_points = character.experience_points
        character.attack(defender, 1, 2)
        character.experience_points.should == experience_points
      end
    end

    describe 'can level' do
      it 'starts at level 1' do
        character.level.should == 1
      end

      it 'levels up after every 1000 experience points' do
        character.instance_variable_set(:@experience_points, 990)
        character.attack(defender, 19, 1)
        character.level.should == 2
      end

      describe 'hit points increase by 5 plus constitution modifier per level' do
        it 'constitution modifier is 0' do
          character.send('level_up')
          character.max_hit_points.should == 10
        end
      end

      describe 'attack roll is increased by 1 for every even level achieved' do
        it 'level is 2' do
          character.send('level_up')
          character.get_attack_roll(18).should == 19
        end

        it 'complex scenario' do
          4.times{character.send('level_up')}
          character.set_ability('strength', 15)
          character.get_attack_roll(13).should == 17
        end
      end
    end

  end
end


