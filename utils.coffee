_ = require 'lodash.min'

# Uses parts variable to calculate body cost from body array
calculateBodyCost = (body) ->
  _.sumBy(body, (part) -> BODYPART_COST[part.toLowerCase()])

getEnergy = (creep) ->
  # check for energy available on the ground if no enemies present
  enemies = creep.room.find(FIND_HOSTILE_CREEPS)
  unless enemies.length
    energy = creep.pos.findClosestByPath(FIND_DROPPED_ENERGY)
    if energy
      pickupResult = creep.pickup(energy)
      return if pickupResult is OK
      return creep.moveTo energy if pickupResult is ERR_NOT_IN_RANGE
  # check for energy available from containers
  container = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) -> (s.structureType is STRUCTURE_CONTAINER or s.structureType is STRUCTURE_STORAGE) and s.store[RESOURCE_ENERGY] >= creep.carryCapacity)
  if container
    withdrawResult = creep.withdraw(container, RESOURCE_ENERGY)
    return if withdrawResult is OK
    return creep.moveTo container if withdrawResult is ERR_NOT_IN_RANGE
  # else harvest
  source = creep.pos.findClosestByPath(FIND_SOURCES_ACTIVE)
  if source
    harvestResult = creep.harvest(source)
    return if harvestResult is OK
    return creep.moveTo source if harvestResult is ERR_NOT_IN_RANGE

# Makes a creep dump any resources that aren't energy into a container
dropOffResources = (creep) ->
  return false unless _.omit(creep.carry, RESOURCE_ENERGY).length
  # container present?
  container = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) ->
    s.structureType == STRUCTURE_CONTAINER and _.sum(_.values(s.store)) < s.storeCapacity
  )
  return false unless container
  resource = _.head(_.keys(_.omit(creep.carry, RESOURCE_ENERGY)))
  creep.moveTo container if creep.transfer(container, resource) is ERR_NOT_IN_RANGE
  return true

# Transforms a parts object with {part: amount} keys into a body array
getBodyFromParts = (parts) ->
  _.flatten(_.map(parts, (val, key) -> _.fill(Array(val), key.toLowerCase())))

generateBody = (energy, options = {}) ->
  opts = {
    ratio: {WORK: 1, CARRY: 1, MOVE: 1}
    scale: {
      min: 1
      max: 50
  }}
  _.assign(opts, options)
  unitCost = calculateBodyCost(getBodyFromParts(opts.ratio))
  scale = _.clamp(_.floor(energy / unitCost), opts.scale.min, opts.scale.max)
  getBodyFromParts(_.zipObject(_.keys(opts.ratio), _.map(opts.ratio, (val) -> val * scale)))

module.exports =
  calculateBodyCost: calculateBodyCost
  getEnergy: getEnergy
  generateBody: generateBody
  dropOffResources: dropOffResources
