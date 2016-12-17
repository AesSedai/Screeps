roleUpgrader =
  run: (creep) ->
    if creep.memory.upgrading and creep.carry.energy is 0
      creep.memory.upgrading = false
      creep.say 'harvesting'
    if !creep.memory.upgrading and creep.carry.energy is creep.carryCapacity
      creep.memory.upgrading = true
      creep.say 'upgrading'
    if creep.memory.upgrading
      if creep.upgradeController(creep.room.controller) is ERR_NOT_IN_RANGE
        creep.moveTo creep.room.controller
    else
      sources = creep.room.find(FIND_SOURCES)
      if creep.harvest(sources[0]) is ERR_NOT_IN_RANGE
        creep.moveTo sources[0]
    return
  build: [WORK, CARRY, MOVE]

module.exports = roleUpgrader
