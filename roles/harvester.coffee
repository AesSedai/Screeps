utils = require 'utils'
roleUpgrader = require 'upgrader'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    if creep.memory.working and creep.carry.energy is 0
      creep.memory.working = false
      creep.say 'harvesting'
    if !creep.memory.working and creep.carry.energy is creep.carryCapacity
      creep.memory.working = true
      creep.say 'harvesting'
    if creep.memory.working
      target = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (structure) ->
        (structure.structureType is STRUCTURE_EXTENSION or structure.structureType is STRUCTURE_SPAWN or structure.structureType is STRUCTURE_TOWER) and structure.energy < structure.energyCapacity
      )
      return creep.moveTo target if target and creep.transfer(target, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
      roleUpgrader.run creep
    else
      utils.getEnergy(creep)
  build: [WORK, CARRY, MOVE]
  ratio: {WORK: 1, MOVE: 1, CARRY: 1}
