roleBuilder = require 'builder'
utils = require 'utils'
_ = require 'lodash.min'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    if creep.memory.working and creep.carry.energy is 0
      creep.memory.working = false
    else if !creep.memory.working and creep.carry.energy is creep.carryCapacity
      creep.memory.working = true
    if creep.memory.working
      # find all walls in the room
      ramparts = creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_RAMPART)
      walls = creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_WALL)
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
