_ = require 'lodash.min'
utils = require 'utils'

module.exports =
  run: (creep) ->
    creep.memory.target = 'W3N5' if _.isUndefined(creep.memory?.target)
    creep.memory.home = creep.room.name if _.isUndefined(creep.memory?.home)
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    creep.memory.working = false if creep.memory.working and creep.carry.energy is 0
    creep.memory.working = true if not creep.memory.working and _.sum(_.values(creep.carry)) is creep.carryCapacity
    return if utils.dropOffResources(creep)
    if creep.memory.working
      if creep.room.name == creep.memory.home
        structure = creep.pos.findClosestByPath(FIND_MY_STRUCTURES, filter: (s) ->
          (s.structureType is STRUCTURE_SPAWN or s.structureType is STRUCTURE_EXTENSION or s.structureType is STRUCTURE_TOWER) and s.energy < s.energyCapacity
        )
        return creep.moveTo structure if structure and creep.transfer(structure, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
        container = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) ->
          s.structureType == STRUCTURE_CONTAINER and _.sum(_.values(s.store)) < s.storeCapacity
        )
        return creep.moveTo container if container and creep.transfer(container, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
      else
        creep.moveTo creep.pos.findClosestByRange(creep.room.findExitTo(creep.memory.home))
    else
      if creep.room.name == creep.memory.target
        return utils.getEnergy(creep)
      else
        return creep.moveTo creep.pos.findClosestByRange(creep.room.findExitTo(creep.memory.target))
  ratio: {WORK: 1, CARRY: 2, MOVE: 2}
