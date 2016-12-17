_ = require('lodash')
roles = require('roles')

population = _.sortBy([
  {
    role: 'largeHarvester'
    amount: 2
    priority: 1
  }
  {
    role: 'builder'
    amount: 2
    priority: 3
  }
  {
    role: 'upgrader'
    amount: 3
    priority: 2
  }
  {
    role: 'repairer'
    amount: 1
    priority: 4
  }
], (o) -> o.priority)

cleanup = ->
  _.map(_.filter(Memory.creeps, (creep, name) -> !Game.creeps[name]), (creep, name) -> delete Memory.creeps[name])

populate = (spawn) ->
  creeps = spawn.room.find(FIND_MY_CREEPS)
  _.map(population, (c) ->
    current = _.filter(creeps, (creep) -> creep.memory.role is c.role).length
    if current < c.amount and spawn.room.energyAvailable > roles[c.role].cost
      console.log 'spawning', c.role
      spawn.createCreep(roles[c.role].build, c.role+'-'+Game.time, {role: c.role})
  )

assignRoles = (spawn) ->
  _.map(Game.creeps, (creep) -> roles[creep.memory.role].run(creep))

log = (spawn) ->
  creeps = spawn.room.find(FIND_MY_CREEPS)
  _.map(population, (c) ->
    console.log spawn.room.name, c.role, c.amount, "(#{_.filter(creeps, (creep) -> creep.memory.role is c.role).length})"
  )
  console.log()

module.exports.loop = ->
  cleanup()
  assignRoles()
  _.map(Game.spawns, (spawn) ->
    populate(spawn)
    log(spawn)
  )
