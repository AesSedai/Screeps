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
      # find all walls in the room
      ramparts = creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_RAMPART)
      target = undefined
      # check for ramparts to repair first
      percentage = 0.001
      while percentage <= 1
        # find a rampart with less than percentage hits
        target = _.find(ramparts, (r) -> (r.hits / r.hitsMax) < percentage )
        break if target
        percentage = percentage + 0.0001
      return creep.moveTo target if target and creep.repair(target) is ERR_NOT_IN_RANGE
      # loop with increasing percentages
      walls = creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_WALL)
      percentage = 0.0001
      while percentage <= 1
        # find a wall with less than percentage hits
        target = _.find(walls, (w) -> (w.hits / w.hitsMax) < percentage )
        break if target
        percentage = percentage + 0.0001
      return creep.moveTo target if target and creep.repair(target) is ERR_NOT_IN_RANGE
      roleBuilder.run creep
    else
      utils.getEnergy(creep)
  ratio: {WORK: 1, MOVE: 1, CARRY: 1}
