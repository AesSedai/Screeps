_ = require 'lodash'
roles = require 'roles'
profiler = require 'screeps-profiler'

population = [
  {
    role: 'largeHarvester'
    amount: 6
    priority: 1
  }
  {
    role: 'upgrader'
    amount: 3
    priority: 2
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
    role: 'miner'
    amount: 1
    priority: 5
  }
]

maxPop = 15

# Remove dead creeps from memory
cleanup = ->
  _.map(Memory.creeps, (creep, name) -> delete Memory.creeps[name] if !Game.creeps[name])

# Spawn creeps for a spawner based on population variable
populate = (spawn) ->
  # Get creeps in room
  creeps = spawn.room.find(FIND_MY_CREEPS)
  return if creeps.length >= maxPop
  # Iterate over population spec, stop once a creep is spawned or if waiting for energy to spawn
  result = _.some(population, (c) ->
    current = _.filter(creeps, (creep) -> creep.memory.role is c.role).length
    # if unable to build in order, then wait to spawn
    if current < c.amount
      if spawn.room.energyAvailable >= roles[c.role].cost
        console.log spawn.room.name, 'Spawning', c.role
        spawn.createCreep(roles[c.role].build, c.role + '-' + Game.time, {role: c.role})
      else
        console.log spawn.room.name, 'Waiting to spawn', c.role
      return true
  )
  # if not waiting and not spawning anything, make harvesters
  unless result
    if spawn.room.energyAvailable >= roles.largeHarvester.cost
      console.log spawn.room.name, 'Spawning largeHarvester'
      spawn.createCreep(roles.harvester.build, 'largeHarvester-' + Game.time, {role: 'largeHarvester'})
    else
      console.log spawn.room.name, 'Waiting to spawn largeHarvester'

# Run creeps with their roles from memory
assignRoles = () ->
  _.map(Game.creeps, (creep) -> roles[creep.memory.role].run(creep))

# Print out information for each spawn
log = (spawn) ->
  creeps = spawn.room.find(FIND_MY_CREEPS)
  console.log spawn.room.name, 'Energy available', spawn.room.energyAvailable
  _.map(population, (c) ->
    console.log spawn.room.name, c.role, c.amount, "(#{_.filter(creeps, (creep) -> creep.memory.role is c.role).length})"
  )
  console.log()

# Main loop
profiler.enable()
module.exports.loop = ->
  profiler.wrap( ->
    cleanup()
    assignRoles()
    _.map(Game.spawns, (spawn) ->
      populate(spawn)
      log(spawn)
    )
  )
