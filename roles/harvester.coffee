roleHarvester =
  run: (creep) ->
    if creep.carry.energy < creep.carryCapacity
      sources = creep.room.find(FIND_SOURCES)
      if creep.harvest(sources[0]) is ERR_NOT_IN_RANGE
        creep.moveTo sources[0]
    else
      targets = creep.room.find(FIND_STRUCTURES, filter: (structure) ->
        (structure.structureType is STRUCTURE_EXTENSION or structure.structureType is STRUCTURE_SPAWN or structure.structureType is STRUCTURE_TOWER) and structure.energy < structure.energyCapacity
      )
      if targets.length > 0
        if creep.transfer(targets[0], RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
          creep.moveTo targets[0]
    return
  build: [WORK, CARRY, MOVE]

module.exports = roleHarvester
