_ = require 'lodash.min'
roles = require 'roles'
utils = require 'utils'
profiler = require 'screeps-profiler'

population = [
  {
    role: 'harvester'
    amount: 3
    priority: 1
  }
  {
    role: 'upgrader'
    amt: 2
    amount: 2
    priority: 2
  }
  {
    role: 'miner'
    amount: 2
    priority: 5
  }
  {
    role: 'builder'
    amount: 2
    priority: 3
  }
  {
    role: 'repairer'
    amount: 2
    priority: 4
  }
  {
    role: 'wallRepairer'
    amount: 2
    priority: 4
  }
]

maxPop = 20

# Remove dead creeps from memory
cleanup = ->
  _.map(Memory.creeps, (creep, name) -> delete Memory.creeps[name] if !Game.creeps[name])

spawnCreep = (spawn, energyToUse, currentEnergy, role) ->
  return if spawn.spawning
  body = utils.generateBody(energyToUse, roles[role].ratio)
  cost = utils.calculateBodyCost(body)
  if currentEnergy >= cost
    console.log spawn.room.name, 'Spawning', role
    spawn.createCreep(body, role + '-' + Game.time, {role: role})
  else
    console.log spawn.room.name, 'Waiting to spawn', role, 'need', cost, 'energy', "(#{cost - currentEnergy} more required)"

handleTowers = (spawn) ->
  towers = spawn.room.find(FIND_STRUCTURES, filter: structureType: STRUCTURE_TOWER)
  # blap if possible
  for tower in towers
    target = tower.pos.findCLosestByRange(FIND_HOSTILE_CREEPS)
    tower.attack(target) if target

# Spawn creeps for a spawner based on population variable
populate = (spawn) ->
  # Get creeps in room
  creeps = spawn.room.find(FIND_MY_CREEPS)
  return if creeps.length >= maxPop

  # ensure harvesters are being made at least
  return spawnCreep(spawn, spawn.room.energyAvailable, spawn.room.energyAvailable, 'harvester') if creeps.length is 0

  # Iterate over population spec, stop once a creep is spawned or if waiting for energy to spawn
  result = _.some(population, (c) ->
    current = _.filter(creeps, memory: role: c.role).length
    return false if current >= c.amount
    spawnCreep(spawn, spawn.room.energyCapacityAvailable, spawn.room.energyAvailable, c.role)
    return true
  )
  # if not waiting and not spawning anything, make harvesters
  spawnCreep(spawn, spawn.room.energyCapacityAvailable, spawn.room.energyAvailable, 'harvester') unless result

# Run creeps with their roles from memory
assignRoles = () ->
  _.map(Game.creeps, (creep) -> roles[creep.memory.role].run(creep))

# Print out information for each spawn
log = (spawn) ->
  console.log spawn.room.name, 'Energy available', spawn.room.energyAvailable, 'population', spawn.room.find(FIND_MY_CREEPS).length, "(#{maxPop})"
  console.log(_.map(population, (c) -> "#{c.role} #{c.amount} (#{_.filter(spawn.room.find(FIND_MY_CREEPS), memory: role: c.role).length})").join(" | "))
  console.log()

# Main loop
profiler.enable()
module.exports.loop = ->
  profiler.wrap( ->
    cleanup()
    assignRoles()
    _.map(Game.spawns, (spawn) ->
      handleTowers(spawn)
      populate(spawn)
      log(spawn)
    )
  )
