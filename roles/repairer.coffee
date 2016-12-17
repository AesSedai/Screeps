utils = require 'utils'
roleBuilder = require 'builder'
roleRepairer =
  run: (creep) ->
    if creep.memory.working and creep.carry.energy is 0
      creep.memory.working = false
      creep.say 'harvesting'
    if !creep.memory.working and creep.carry.energy is creep.carryCapacity
      creep.memory.working = true
      creep.say 'repairing'
    if creep.memory.working
      # Repairing
      target = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) ->
        s.hits < s.hitsMax and s.structureType != STRUCTURE_WALL
      )
      if target
        creep.moveTo target if creep.repair(target) is ERR_NOT_IN_RANGE
      else
        roleBuilder.run creep
    else
      container = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) ->
        s.structureType is STRUCTURE_CONTAINER and s.store[RESOURCE_ENERGY] >= creep.carryCapacity
      )
      if container
        creep.moveTo container if creep.withdraw(container, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
      else
        source = creep.pos.findClosestByPath(FIND_SOURCES_ACTIVE)
        creep.moveTo source if creep.harvest(source) is ERR_NOT_IN_RANGE
  build: [WORK, CARRY, MOVE]

roleRepairer.cost = utils.calculateBodyCost(roleRepairer.build)

module.exports = roleRepairer
