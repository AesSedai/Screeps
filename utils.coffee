_ = require 'lodash.min'

# Uses parts variable to calculate body cost from body array
calculateBodyCost = (body) ->
  _.sumBy(body, (part) -> BODYPART_COST[part.toLowerCase()])

getEnergy = (creep) ->
  # check for energy available on the ground
  energy = creep.pos.findClosestByPath(FIND_DROPPED_ENERGY)
  return creep.moveTo energy if energy and creep.pickup(energy) is ERR_NOT_IN_RANGE
  # check for energy available from containers
  container = creep.pos.findClosestByPath(FIND_STRUCTURES, filter: (s) -> s.structureType is STRUCTURE_CONTAINER and s.store[RESOURCE_ENERGY] >= creep.carryCapacity)
  return creep.moveTo container if container and creep.withdraw(container, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
  # else harvest
  source = creep.pos.findClosestByPath(FIND_SOURCES_ACTIVE)
  return creep.moveTo source if source and creep.harvest(source) is ERR_NOT_IN_RANGE

# Transforms a parts object with {part: amount} keys into a body array
getBodyFromParts = (parts) ->
  _.flatten(_.map(parts, (val, key) -> _.fill(Array(val), key.toLowerCase())))

generateBody = (energy, partsRatio, scale = undefined) ->
  unitCost = calculateBodyCost(getBodyFromParts(partsRatio))
  scale ?= _.floor(energy / unitCost)
  getBodyFromParts(_.zipObject(_.keys(partsRatio), _.map(partsRatio, (val) -> val * scale)))

module.exports =
  calculateBodyCost: calculateBodyCost
  getEnergy: getEnergy
  generateBody: generateBody
