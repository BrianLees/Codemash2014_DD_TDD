require_relative 'spec_helper'

describe 'Rogue' do
  let(:rogue){Rogue.new}
  let(:defender){Character.new}

  it 'can create a rogue' do
    Rogue.new.should_not be_nil
  end

  describe 'critical hit damage' do
    describe 'does triple damage on critical hits' do
      let(:roll){20}

      it '0 stength modifier' do
        rogue.get_damage(roll).should == 3
      end

      it 'positive strength modifier' do
        rogue.set_ability('dexterity', 20)
        rogue.get_damage(roll).should == 33
      end
    end
  end

  describe 'ignores opponent dexterity modifier (if positive)' do
    it 'dexterity modifier is positive' do
      roll = 11
      defender.set_ability('dexterity', 20)
      defender_start_health = defender.current_hit_points
      damage = rogue.get_damage(roll)
      rogue.attack(defender, roll, damage)
      defender.current_hit_points.should == defender_start_health - damage
    end

    it 'dexterity modifier is negative' do
      roll = 9
      defender.set_ability('dexterity', 8)
      defender_start_health = defender.current_hit_points
      damage = rogue.get_damage(roll)
      rogue.attack(defender, roll, damage)
      defender.current_hit_points.should == defender_start_health - damage
    end

    it 'dexterity modifier is 0' do
      roll = 10
      defender.set_ability('dexterity', 11)
      defender_start_health = defender.current_hit_points
      damage = rogue.get_damage(roll)
      rogue.attack(defender, roll, damage)
      defender.current_hit_points.should == defender_start_health - damage
    end
  end

  describe 'adds dexterity modifier to attacks instead of strength' do
    it 'dexterity modifier of 2' do
      roll = 10
      rogue.set_ability('dexterity', 15)
      rogue.get_damage(roll).should == 3
    end
  end
end