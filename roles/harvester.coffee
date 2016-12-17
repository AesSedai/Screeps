utils = require 'utils'
roleUpgrader = require 'upgrader'
roleHarvester =
  run: (creep) ->
    if creep.carry.energy < creep.carryCapacity
      source = creep.pos.findClosestByPath(FIND_SOURCES_ACTIVE)
      creep.moveTo source if creep.harvest(source) is ERR_NOT_IN_RANGE
    else
      target = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (structure) ->
        (structure.structureType is STRUCTURE_EXTENSION or structure.structureType is STRUCTURE_SPAWN or structure.structureType is STRUCTURE_TOWER) and structure.energy < structure.energyCapacity
      )
      if target
        creep.moveTo target if creep.transfer(target, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
      else
        roleUpgrader.run creep
  build: [WORK, CARRY, MOVE]

roleHarvester.cost = utils.calculateBodyCost(roleHarvester.build)

module.exports = roleHarvester
