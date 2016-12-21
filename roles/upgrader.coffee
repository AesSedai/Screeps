_ = require 'lodash.min'
utils = require 'utils'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    creep.memory.working = false if creep.memory.working and creep.carry.energy is 0
    creep.memory.working = true if not creep.memory.working and _.sum(_.values(creep.carry)) is creep.carryCapacity
    return if utils.dropOffResources(creep)
    if creep.memory.working
      creep.moveTo creep.room.controller if creep.upgradeController(creep.room.controller) is ERR_NOT_IN_RANGE
    else
      utils.getEnergy(creep)
  build: [WORK, CARRY, MOVE, MOVE]
  ratio: {WORK: 1, CARRY: 1, MOVE: 2}
