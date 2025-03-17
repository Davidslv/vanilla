require_relative 'base_command'
require_relative '../components/combat_component'
require_relative '../components/stats_component'
require_relative '../components/transform_component'
require_relative '../support/tile_type'

module Vanilla
  module Commands
    class CombatCommand < BaseCommand
      attr_reader :target

      def initialize(world:, entity:, target:)
        super(world: world, entity: entity)
        @target = target
      end

      def can_execute?
        return false unless entity && target
        
        attacker_combat = get_component(Components::CombatComponent)
        target_stats = target.get_component(Components::StatsComponent)
        
        return false unless attacker_combat && target_stats
        return false unless target_stats.alive?
        
        # Verify entities are adjacent
        attacker_transform = get_component(Components::TransformComponent)
        target_transform = target.get_component(Components::TransformComponent)
        
        return false unless adjacent?(attacker_transform, target_transform)
        
        true
      end

      def execute
        return false unless can_execute?

        attacker_combat = get_component(Components::CombatComponent)
        target_stats = target.get_component(Components::StatsComponent)
        
        damage = calculate_damage(attacker_combat, target_stats)
        target_stats.take_damage(damage)

        emit_event(:combat_executed, 
          attacker: entity,
          target: target,
          damage: damage
        )

        if !target_stats.alive?
          handle_target_death
          true
        else
          emit_event(:target_survived,
            target: target,
            remaining_health: target_stats.health
          )
          false
        end
      end

      private

      def calculate_damage(attacker_combat, target_stats)
        base_damage = attacker_combat.attack
        defense = target_stats.defense
        [base_damage - defense, 1].max
      end

      def handle_target_death
        target_transform = target.get_component(Components::TransformComponent)
        grid = target_transform.grid
        row, col = target_transform.position

        # Update the grid
        cell = grid.cell_at(row, col)
        cell.tile = Support::TileType::FLOOR
        cell.content = nil

        # Award experience to the attacker
        if attacker_stats = get_component(Components::StatsComponent)
          exp_gained = calculate_experience(target)
          attacker_stats.gain_experience(exp_gained)
          emit_event(:experience_gained, amount: exp_gained)
        end

        emit_event(:target_defeated, target: target)
      end

      def calculate_experience(target)
        target_stats = target.get_component(Components::StatsComponent)
        base_exp = target_stats.level * 10
        [base_exp, 1].max
      end

      def adjacent?(transform1, transform2)
        return false unless transform1 && transform2
        
        row1, col1 = transform1.position
        row2, col2 = transform2.position
        
        (row1 - row2).abs + (col1 - col2).abs == 1
      end
    end
  end
end 