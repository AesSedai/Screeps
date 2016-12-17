utils = require('utils')
roleHarvester = require('harvester')
roleLargeHarvester =
  run: (creep) ->
    roleHarvester.run(creep)
  build: [WORK, WORK, CARRY, MOVE]

roleLargeHarvester.cost = utils.calculateBodyCost(roleLargeHarvester.build)

module.exports = roleLargeHarvester
