utils = require 'utils'
_ = require 'lodash'

setContainer = (creep) ->
  # return if creep.memory.container
  unclaimedSources = _.filter(creep.room.find(FIND_SOURCES), (s) -> _.every(_.filter(Memory.creeps, (c) -> c.role is 'miner' and not _.isUndefined(c?.source)), (c) -> c?.source != s.id))
  claimed = _.some(creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_CONTAINER), (c) ->
    return true if creep?.memory?.source
    nearSource = _.find(unclaimedSources, (s) -> c.pos.isNearTo(s))
    if nearSource
      creep.memory.source = nearSource.id
      creep.memory.container = c.id
      return true
    return false
  )
  if claimed
    console.log 'Claimed source', creep.memory.source, 'for miner', creep
  else
    console.log 'No container for miner', creep, 'for source', creep.memory.source

roleMiner =
  run: (creep) ->
    # find unmined resource and camp it out
    setContainer(creep) unless creep.memory.container
    return unless creep.memory.source and creep.memory.container
    # move onto a container next to a source
    creep.moveTo Game.getObjectById(creep.memory.container) if creep.harvest(Game.getObjectById(creep.memory.source)) is ERR_NOT_IN_RANGE
  build: [WORK, MOVE]
  ratio: {WORK: 5, MOVE: 1}

roleMiner.cost = utils.calculateBodyCost(roleMiner.build)

module.exports = roleMiner
