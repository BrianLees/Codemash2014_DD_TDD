require_relative 'spec_helper'

describe 'WarMonk' do
  let (:war_monk){WarMonk.new}
  it 'can create a war monk' do
    WarMonk.new.should_not be_nil
  end

  describe 'it has 6 hit points per level' do
    it 'level is 1' do
      war_monk.max_hit_points.should == 6
    end
  end

  describe '3 points of base damage vs 1' do
    it 'no modifier will do 3 damage' do
      war_monk.get_damage(19).should == 3
    end

    it 'with a negative modifier will stay above the minium damage' do
      war_monk.set_ability('strength', 9)
      war_monk.get_damage(19).should == 2
    end

    it 'will still do 1 as a minimum damage' do
      war_monk.set_ability('strength', 4)
      war_monk.get_damage(19).should == 1
    end
  end

  describe 'add wisdom modifier (if positive) to armor class in addition to Dexterity' do
    it 'positive wisdom increases armor class' do
      war_monk.set_ability('wisdom', 12)
      war_monk.armor_class.should == 11
    end

    it 'positive wisdom and dexterity modifier changes armor' do
      war_monk.set_ability('wisdom', 14)
      war_monk.set_ability('dexterity', 6)
      war_monk.armor_class.should == 10
    end

    it 'negative wisdom does not modify armor class' do
      war_monk.set_ability('wisdom', 8)
      war_monk.armor_class.should == 10
    end
  end

  describe 'attack modifier increases by 1 every second and third level' do
    it 'is level 3' do
      2.times{war_monk.send('level_up')}
      war_monk.get_attack_roll(10).should == 12
    end

    it 'is level 6' do
      5.times{war_monk.send('level_up')}
      war_monk.get_attack_roll(10).should == 14
    end
  end
end
