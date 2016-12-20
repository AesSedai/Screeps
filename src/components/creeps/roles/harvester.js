"use strict";
var _ = require("lodash");
var creepActions = require("../creepActions");
/**
 * Runs all creep actions.
 *
 * @export
 * @param {Creep} creep
 */
function run(creep) {
    var spawn = creep.room.find(FIND_MY_SPAWNS)[0];
    var energySource = creep.room.find(FIND_SOURCES_ACTIVE)[0];
    if (creepActions.needsRenew(creep)) {
        creepActions.moveToRenew(creep, spawn);
    }
    else if (_.sum(_.values(creep.carry)) === creep.carryCapacity) {
        _moveToDropEnergy(creep, spawn);
    }
    else {
        _moveToHarvest(creep, energySource);
    }
}
exports.run = run;
function _tryHarvest(creep, target) {
    return creep.harvest(target);
}
function _moveToHarvest(creep, target) {
    if (_tryHarvest(creep, target) === ERR_NOT_IN_RANGE) {
        creepActions.moveTo(creep, target.pos);
    }
}
function _tryEnergyDropOff(creep, target) {
    return creep.transfer(target, RESOURCE_ENERGY);
}
function _moveToDropEnergy(creep, target) {
    if (_tryEnergyDropOff(creep, target) === ERR_NOT_IN_RANGE) {
        creepActions.moveTo(creep, target.pos);
    }
}
