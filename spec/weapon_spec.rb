require_relative 'spec_helper'

describe 'Weapons' do
  let(:character){Character.new}
  let(:defender){Character.new}
  let(:waraxe_wielder) do
    d = Character.new
    waraxe = Weapon.new(:waraxe)
    d.equip_weapon(waraxe)
    d
  end

  let(:rogue_waraxe_wielder) do
    d = Rogue.new
    waraxe = Weapon.new(:waraxe)
    d.equip_weapon(waraxe)
    d
  end

  it 'each character can equip a weapon' do
    character.equip_weapon('Sword')
    character.weapon.should == 'Sword'
  end

  it 'each character can only equip one weapon' do
    character.equip_weapon('Sword')
    character.equip_weapon('Gunblade')
    character.weapon.should_not == 'Sword'
  end

  context 'longsword' do
    it 'it does 5 points of damage' do
      sword = Weapon.new(:longsword)
      character.equip_weapon(sword)
      character.get_damage(10).should == 6
    end
  end

  context 'waraxe' do
    it 'it has 6 points of base weapon damage and 2 extra damage' do
      waraxe_wielder.get_damage(15).should == 9
    end
    it 'adds +2 to attack roll' do
      waraxe_wielder.get_attack_roll(11).should == 13
    end
    it 'does triple damage on a critical hit for non Rogues' do
      waraxe_wielder.get_damage(20).should == ((1 + 6) * 3) + 2
    end
    it 'does quadruple damage on a critical hit for Rogues' do
      rogue_waraxe_wielder.get_damage(20).should == (1 + 6) * 4 + 2
    end
    it 'does quadruple damage on a critical hit for Rogues and strength modifiers' do
      rogue_waraxe_wielder.set_ability('dexterity', 14)
      rogue_waraxe_wielder.get_damage(20).should == (1 + 6 + 4) * 4 + 2
    end
  end

  context 'elven longsword' do
    context 'used by an elf against an non-orc' do
      let(:roll){15}
      let(:defender){Character.new('Halfling')}
      let(:attacker) do
        a = Character.new('Elf')
        a.equip_weapon(Weapon.new(:elven_longsword))
        a.attack_target = defender
        a
      end

      it 'has 5 points of base weapon damage and 2 extra damage' do
        attacker.get_damage(roll).should == (1 + 5 + 2)
      end

      it 'has +2 to attack roll' do
        pending
      end
    end

    context 'used by an elf against an orc' do
      it 'has 5 points of base weapon damage and 5 extra damage' do
        pending
      end

      it 'has +5 to attack roll' do
        pending
      end
    end

    context 'used by a non-elf against a non-orc' do
      it 'has 5 points of base weapon damage and 1 extra damage' do
        pending
      end

      it 'has +1 to attack roll' do
        pending
      end
    end

    context 'used by a non-elf against an orc' do
      it 'has 5 points of base weapon damage and 2 extra damage' do
        pending
      end

      it 'has +2 to attack roll' do
        pending
      end
    end
  end
end