require_relative 'spec_helper'

describe 'Paladin' do
  let(:paladin){Paladin.new}
  let(:evil_defender) do
    d = Character.new
    d.alignment = 'Evil'
    d
  end

  it 'can create a paladin' do
    Paladin.new.should_not be_nil
  end

  describe 'it has 6 hit points per level' do
    it 'level is 1' do
      paladin.max_hit_points.should == 8
    end
  end

  describe 'it has attack and damage modifiers against evil characters' do
    it 'add 2 to attack roll against evil characters' do
      paladin.attack(evil_defender, 9, 1)
      evil_defender.current_hit_points.should < evil_defender.max_hit_points
    end

    it 'add 2 to damage against an evil character' do
      paladin.attack(evil_defender, 10, 1)
      evil_defender.current_hit_points.should == 2
    end

    it 'crits do triple damage against evil characters' do
      paladin.attack(evil_defender, 20, 6)
      evil_defender.current_hit_points.should == evil_defender.max_hit_points - ((1 + 2 ) * 3)
    end

    it 'crits do triple damage against evil, and strength modifiers' do
      paladin.set_ability('strength', 20)
      paladin.attack(evil_defender, 20, 6)
      evil_defender.current_hit_points.should == evil_defender.max_hit_points - ((1 + 2 + (5 * 2)) * 3)
    end
   end
  end
