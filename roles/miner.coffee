utils = require 'utils'
_ = require 'lodash'

setContainer = (creep) ->
  return if creep.memory.container
  unclaimedSources = _.filter(creep.room.find(FIND_SOURCES), (s) -> _.every(Memory.creeps, (c) -> _.isUndefined(c?.memory?.source) or c?.memory?.source is not s.id))
  _.map(creep.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_CONTAINER), (c) ->
    nearSource = _.find(unclaimedSources, (s) -> c.pos.isNearTo(s))
    creep.memory.source = nearSource.id if nearSource
    creep.memory.container = c.id
    return
  )
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
