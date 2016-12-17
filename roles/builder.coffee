utils = require('utils')
roleBuilder =
  run: (creep) ->
    if creep.memory.building and creep.carry.energy is 0
      creep.memory.building = false
      creep.say 'harvesting'
    if !creep.memory.building and creep.carry.energy is creep.carryCapacity
      creep.memory.building = true
      creep.say 'building'
    if creep.memory.building
      target = creep.pos.findClosestByPath(FIND_CONSTRUCTION_SITES)
      creep.moveTo target if target and creep.build(target) is ERR_NOT_IN_RANGE
    else
      source = creep.pos.findClosestByPath(FIND_SOURCES_ACTIVE)
      creep.moveTo source if creep.harvest(source) is ERR_NOT_IN_RANGE
    return
  build: [WORK, CARRY, MOVE]

roleBuilder.cost = utils.calculateBodyCost(roleBuilder.build)

module.exports = roleBuilder
