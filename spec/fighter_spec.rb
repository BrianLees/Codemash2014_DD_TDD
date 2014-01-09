require_relative 'spec_helper'

describe 'Fighter' do
  let(:fighter){Fighter.new}

  it 'can create a fighter' do
    Fighter.new.should_not be_nil
  end

  describe 'fighter specific stats' do
    describe 'attack roll is increased by 1 for every level' do
      it 'level is 1' do
        fighter.get_attack_roll(18).should == 18
      end

      it 'complex scenario' do
        4.times{fighter.send('level_up')}
        fighter.set_ability('strength', 15)
        fighter.get_attack_roll(13).should == 19
      end
    end

    describe 'gains 10 hit points per level' do
      it 'level is 1' do
        fighter.max_hit_points.should == 10
      end
    end

    describe 'hit points increase by 10 plus constitution modifier per level' do
      it 'constitution modifier is 0' do
        fighter.send('level_up')
        fighter.max_hit_points.should == 20
      end
    end
  end

  context 'race and weapon integration' do
    it 'Dwarf fighter with a longsword with a +3 strength modifier attacking an Orc Rogue' do
      fighter = Fighter.new('Dwarf')
      fighter.equip_weapon(Weapon.new(:longsword))
      fighter.set_ability('strength', 16)

      rogue = Rogue.new('Orc')

      # 1 base + 2 vs orc + 3 str + 5 longsword
      expected_life = rogue.current_hit_points - 11
      roll = 18
      fighter.attack_target = rogue
      fighter.attack(fighter.get_attack_roll(roll), fighter.get_damage(roll))
      rogue.current_hit_points.should == expected_life
    end
  end
end