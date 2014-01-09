require_relative 'spec_helper'

describe 'Races' do
  it 'all characters default to human' do
    Character.new.race.class.should == Human
  end

  context 'Orc' do
    let(:orc){Character.new('Orc')}
    context 'modifiers' do
      it 'strength modifier gets +2' do
        orc.get_modifier('strength').should == 2
      end
      it 'dexterity modifier gets 0' do
        orc.get_modifier('dexterity').should == 0
      end
      it 'constituion modifier gets 0' do
        orc.get_modifier('constitution').should == 0
      end
      it 'intelligece modifier gets -1' do
        orc.get_modifier('intelligence').should == -1
      end
      it 'wisdom modifier gets -1' do
        orc.get_modifier('wisdom').should == -1
      end
      it 'charisma modifier gets -1' do
        orc.get_modifier('charisma').should == -1
      end
    end
    context 'armor class' do
      it 'armor class gets + 2' do
        orc.armor_class.should == 12
      end
    end
  end

  context 'Dwarf' do
    let(:dwarf){Character.new('Dwarf')}

    context 'modifiers' do
      it 'constitution modifer gets +1' do
        dwarf.get_modifier('constitution').should == 1
      end
      it 'charisma modifer gets -1' do
        dwarf.get_modifier('charisma').should == -1
      end
    end

    it 'constitution modifier doubles when adding hit points to level' do
      dwarf.set_ability('constitution', 14)
      dwarf.send('level_up')
      dwarf.max_hit_points.should == 22
    end

    context 'when attack an orc' do
      let(:defending_orc){Character.new('Orc')}
      it '+2 attack roll' do
        dwarf.attack_target = defending_orc
        dwarf.get_attack_roll(10).should == 12
      end

      it '+2 attack damage' do
        dwarf.attack_target = defending_orc
        dwarf.get_damage(10).should == 3
      end
    end
  end

  context 'Elf' do
    let(:elf){Character.new('Elf')}

    context 'Modifiers' do
      it 'dexterity modifier gets +1' do
        elf.get_modifier('dexterity').should == 1
      end

      it 'constitution modifier gets -1' do
        elf.get_modifier('constitution').should == -1
      end
    end

    context 'critical hit range' do
      it 'critical hit range is increased by 1 for elves' do
        elf.critical_hit?(19).should be_true
      end
    end

    it 'armor class vs orcs' do
      starting_hit_points = elf.current_hit_points
      orc = Character.new('Orc')
      orc.attack_target = elf
      orc.attack(12, 1)
      elf.current_hit_points.should == starting_hit_points
    end
  end

  context 'Halfling' do
    let(:halfling){Character.new('Halfling')}

    context 'Modifiers' do
      it 'dexterity modifier gets +1' do
        halfling.get_modifier('dexterity').should == 1
      end
      it 'strength modifier gets -1' do
        halfling.get_modifier('strength').should == -1
      end
    end

    it 'armor class vs non-halflings' do
      starting_hit_points = halfling.current_hit_points
      orc = Character.new('Orc')
      orc.attack_target = halfling
      orc.attack(12, 1)
      halfling.current_hit_points.should == starting_hit_points
    end

    it 'armor class vs halflings' do
      starting_hit_points = halfling.current_hit_points
      attacker = Character.new('Halfling')
      attacker.attack_target = halfling
      attacker.attack(12, 1)
      halfling.current_hit_points.should == starting_hit_points - 1
    end
  end
end
