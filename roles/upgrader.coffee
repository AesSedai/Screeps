utils = require 'utils'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    if creep.memory.working and creep.carry.energy is 0
      creep.memory.working = false
      creep.say 'harvesting'
    if !creep.memory.working and creep.carry.energy is creep.carryCapacity
      creep.memory.working = true
      creep.say 'upgrading'
    if creep.memory.working
      creep.moveTo creep.room.controller if creep.upgradeController(creep.room.controller) is ERR_NOT_IN_RANGE
    else
      utils.getEnergy(creep)
  build: [WORK, CARRY, MOVE, MOVE]
  ratio: {WORK: 1, MOVE: 2, CARRY: 1}
