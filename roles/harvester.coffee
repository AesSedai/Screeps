_ = require 'lodash.min'
utils = require 'utils'
roleUpgrader = require 'upgrader'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    creep.memory.working = false if creep.memory.working and creep.carry.energy is 0
    creep.memory.working = true if not creep.memory.working and _.sum(_.values(creep.carry)) is creep.carryCapacity
    return if utils.dropOffResources(creep)
    if creep.memory.working
      target = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (structure) ->
        structure.structureType is STRUCTURE_TOWER and structure.energy < structure.energyCapacity
      )
      if target
        transferResult = creep.transfer(target, RESOURCE_ENERGY)
        return if transferResult is OK
        return creep.moveTo target if transferResult is ERR_NOT_IN_RANGE
      target = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (structure) ->
        (structure.structureType is STRUCTURE_EXTENSION or structure.structureType is STRUCTURE_SPAWN) and structure.energy < structure.energyCapacity
      )
      if target
        transferResult = creep.transfer(target, RESOURCE_ENERGY)
        return if transferResult is OK
        return creep.moveTo target if transferResult is ERR_NOT_IN_RANGE
      roleUpgrader.run creep
    else
      utils.getEnergy(creep)
  options: {
    ratio: {WORK: 1, CARRY: 1, MOVE: 1}
    scale:
      max: 3
  }
