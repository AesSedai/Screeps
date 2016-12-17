_ = require('lodash')
roles = require('roles')

population =
  harvester: 4

populate = ->
  _.map(population, (amt, role) ->
    current = _.filter(Game.creeps, (creep) -> creep.memory.role is role)
    Game.spawns['Origin'].createCreep(roles[role].build, role+'-'+Game.time, {role: role}) if current < amt
  )

assignRoles = ->
  _.map(Game.creeps, (creep) -> roles[creep.memory.role].run(creep))

module.exports.loop = ->
  populate()
  assignRoles()
