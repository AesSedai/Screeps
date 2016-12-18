_ = require 'lodash'

parts =
  MOVE: 50
  WORK: 100
  CARRY: 50
  ATTACK: 80
  RANGED_ATTACK: 150
  HEAL: 250
  CLAIM: 600
  TOUGH: 10

# Uses parts variable to calculate body cost from body array
calculateBodyCost = (body) ->
  _.reduce(body, ((sum, n) -> sum += parts[n.toUpperCase()]), 0)

getEnergy = (creep) ->
  # check for energy available from containers
  container = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) -> s.structureType is STRUCTURE_CONTAINER and s.store[RESOURCE_ENERGY] >= creep.carryCapacity)
  return creep.moveTo container if container and creep.withdraw(container, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
  # else harvest
  source = creep.pos.findClosestByPath(FIND_SOURCES_ACTIVE)
  return creep.moveTo source if creep.harvest(source) is ERR_NOT_IN_RANGE

# Transforms a parts object with {part: amount} keys into a body array
getBodyFromParts = (parts) ->
  _.flatten(_.map(parts, (val, key) -> _.fill(Array(val), key.toLowerCase())))

generateBody = (energy, partsRatio) ->
  unitCost = calculateBodyCost(getBodyFromParts(partsRatio))
  scale = _.floor(energy / unitCost)
  getBodyFromParts(_.zipObject(_.keys(partsRatio), _.map(partsRatio, (val) -> val * scale)))

module.exports =
  calculateBodyCost: calculateBodyCost
  getEnergy: getEnergy
  generateBody: generateBody
