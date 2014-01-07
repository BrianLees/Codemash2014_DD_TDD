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
      character.hit_points.should == 5
    end
  end

  describe 'can attack' do
    it 'if roll beats armor class, it is a hit' do
      roll = character.armor_class
      character.hit?(roll).should be_true
    end

    it 'if roll does not beat armor class, it is a miss' do
      roll = character.armor_class - 1
      character.hit?(roll).should be_false
    end
  end

  describe 'can be damaged' do
    it 'takes 1 point of damage when hit' do
      roll = character.armor_class
      hit_points = defender.hit_points
      attacker.attack(defender, roll)
      defender.hit_points.should == hit_points - 1
    end

    it 'critical hit if roll is 20' do
      roll = 20
      character.critical_hit?(roll).should be_true
    end

    it 'critical hits do double damage' do
      roll = 20
      hit_points = defender.hit_points
      attacker.attack(defender, roll)
      defender.hit_points.should == hit_points - 2
    end

    it 'can kill a character with 0 or less hit points' do
      [0, -1].each do |hit_points|
        character.hit_points = hit_points
        character.should be_dead
      end
    end

    it 'a character with more than 0 hit points is not dead' do
      character.hit_points = 1
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
    end
  end
end


