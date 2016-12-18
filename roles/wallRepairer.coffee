roleBuilder = require 'builder'
utils = require 'utils'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    if creep.memory.working == true and creep.carry.energy == 0
      creep.memory.working = false
    else if creep.memory.working == false and creep.carry.energy == creep.carryCapacity
      creep.memory.working = true
    if creep.memory.working == true
      # find all walls in the room
      walls = creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_WALL)
      target = undefined
      # loop with increasing percentages
      percentage = 0.0001
      while percentage <= 1
        # find a wall with less than percentage hits
        # if there is one
        target = _.find(walls, (w) -> (w.hits / w.hitsMax) < percentage )
        break if target
        percentage = percentage + 0.0001
        # if we find a wall that has to be repaired
      return creep.moveTo target if target and creep.repair(target) == ERR_NOT_IN_RANGE
      roleBuilder.run creep
    else
      utils.getEnergy(creep)
  ratio: {WORK: 1, MOVE: 1, CARRY: 1}
