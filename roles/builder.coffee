_ = require 'lodash.min'
utils = require 'utils'
roleUpgrader = require 'upgrader'

module.exports =
  run: (creep) ->
    creep.memory.working = false if _.isUndefined(creep.memory?.working)
    creep.memory.working = false if creep.memory.working and creep.carry.energy is 0
    creep.memory.working = true if not creep.memory.working and _.sum(_.values(creep.carry)) is creep.carryCapacity
    return if utils.dropOffResources(creep)
    if creep.memory.working
      target = creep.pos.findClosestByPath(FIND_CONSTRUCTION_SITES)
      if target
        buildStatus = creep.build(target)
        return if buildStatus is OK
        return creep.moveTo(target) if buildStatus is ERR_NOT_IN_RANGE
      # check to see if any ramparts / walls are at minimum safe health
      ramparts = creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_RAMPART)
      target = _.find(ramparts, (r) -> (r.hits / r.hitsMax) < 0.001 )
      if target
        repairStatus = creep.repair(target)
        return if repairStatus is OK
        return creep.moveTo(target) if repairStatus is ERR_NOT_IN_RANGE
      walls = creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_WALL)
      target = _.find(walls, (w) -> (w.hits / w.hitsMax) < 0.0001 )
      if target
        repairStatus = creep.repair(target)
        return if repairStatus is OK
        return creep.moveTo(target) if repairStatus is ERR_NOT_IN_RANGE
      # if nothing else to do, upgrade
      roleUpgrader.run creep
    else
      utils.getEnergy(creep)
  build: [WORK, CARRY, MOVE]
  ratio: {WORK: 1, CARRY: 1, MOVE: 1}
