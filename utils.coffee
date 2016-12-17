_ = require('lodash')
parts =
  MOVE: 50
  WORK: 100
  CARRY: 50
  ATTACK: 80
  RANGED_ATTACK: 150
  HEAL: 250
  CLAIM: 600
  TOUGH: 10

calculateBodyCost = (body) ->
  _.reduce(body, ((sum, n) -> sum += parts[n.toUpperCase()]), 0)

module.exports =
  calculateBodyCost: calculateBodyCost
