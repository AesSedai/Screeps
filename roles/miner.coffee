utils = require 'utils'
_ = require 'lodash'

setSource = (creep) ->
  return if creep.memory.source
  # find unclaimed source
  source = _.find(creep.room.find(FIND_SOURCES), (s) -> _.every(Memory.creeps, (c) -> _.isUndefined(c?.memory?.source) or c?.memory?.source is not s))
  return creep.memory.source = source if source
  console.log 'No source for miner', creep

setContainer = (creep) ->
  return unless creep.memory.source
  return if creep.memory.container
  container = _.find(creep.room.find(STRUCTURE_CONTAINER), (c) -> creep.memory.source.isNearTo(c))
  console.log 'container', container
  return creep.memory.container = container if container
  console.log 'No container for miner', creep, 'for source', creep.memory.source.id

roleMiner =
  run: (creep) ->
    # find unmined resource and camp it out
    setSource(creep) unless creep.memory.source
    setContainer(creep) unless creep.memory.container
    return unless creep.memory.source and creep.memory.container
    # move onto a container next to a source
    creep.moveTo creep.memory.source if creep.harvest(creep.memory.source) is ERR_NOT_IN_RANGE
  build: [WORK, MOVE]

roleMiner.cost = utils.calculateBodyCost(roleMiner.build)

module.exports = roleMiner
