_ = require 'lodash.min'
utils = require 'utils'
roleBuilder = require 'builder'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    creep.memory.working = false if creep.memory.working and creep.carry.energy is 0
    creep.memory.working = true if not creep.memory.working and _.sum(_.values(creep.carry)) is creep.carryCapacity
    return if utils.dropOffResources(creep)
    if creep.memory.working
      # Repairing
      target = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) ->
        s.hits < s.hitsMax and s.structureType != STRUCTURE_WALL and s.structureType != STRUCTURE_RAMPART
      )
      if target
        repairStatus = creep.repair(target)
        return if repairStatus is OK
        return creep.moveTo(target) if repairStatus is ERR_NOT_IN_RANGE
      roleBuilder.run creep
    else
      utils.getEnergy(creep)
  build: [WORK, CARRY, MOVE]
  ratio: {WORK: 1, CARRY: 1, MOVE: 1}
