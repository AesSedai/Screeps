utils = require 'utils'
roleBuilder = require 'builder'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    if creep.memory.working and creep.carry.energy is 0
      creep.memory.working = false
      creep.say 'harvesting'
    if !creep.memory.working and creep.carry.energy is creep.carryCapacity
      creep.memory.working = true
      creep.say 'repairing'
    if creep.memory.working
      # Repairing
      target = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) ->
        s.hits < s.hitsMax and s.structureType != STRUCTURE_WALL and s.structureType != STRUCTURE_RAMPART
      )
      return creep.moveTo target if target and creep.repair(target) is ERR_NOT_IN_RANGE
      roleBuilder.run creep
    else
      utils.getEnergy(creep)
  build: [WORK, CARRY, MOVE]
  ratio: {WORK: 1, MOVE: 1, CARRY: 1}
