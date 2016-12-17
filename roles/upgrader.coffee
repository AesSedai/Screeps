utils = require 'utils'

roleUpgrader =
  run: (creep) ->
    if creep.memory.upgrading and creep.carry.energy is 0
      creep.memory.upgrading = false
      creep.say 'harvesting'
    if !creep.memory.upgrading and creep.carry.energy is creep.carryCapacity
      creep.memory.upgrading = true
      creep.say 'upgrading'
    if creep.memory.upgrading
      creep.moveTo creep.room.controller if creep.upgradeController(creep.room.controller) is ERR_NOT_IN_RANGE
    else
      utils.getEnergy(creep)
  build: [WORK, CARRY, MOVE, MOVE]

roleUpgrader.cost = utils.calculateBodyCost(roleUpgrader.build)

module.exports = roleUpgrader
