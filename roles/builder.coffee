roleBuilder =
  run: (creep) ->
    if creep.memory.building and creep.carry.energy is 0
      creep.memory.building = false
      creep.say 'harvesting'
    if !creep.memory.building and creep.carry.energy is creep.carryCapacity
      creep.memory.building = true
      creep.say 'building'
    if creep.memory.building
      targets = creep.room.find(FIND_CONSTRUCTION_SITES)
      if targets.length
        if creep.build(targets[0]) is ERR_NOT_IN_RANGE
          creep.moveTo targets[0]
    else
      sources = creep.room.find(FIND_SOURCES)
      if creep.harvest(sources[0]) is ERR_NOT_IN_RANGE
        creep.moveTo sources[0]
    return
  build: [WORK, CARRY, MOVE]

module.exports = roleBuilder
