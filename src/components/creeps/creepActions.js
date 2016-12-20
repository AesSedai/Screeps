"use strict";
var Config = require("../../config/config");
var _ = require("lodash");
/**
 * Shorthand method for `Creep.moveTo()`.
 *
 * @export
 * @param {Creep} creep
 * @param {(Structure | RoomPosition)} target
 * @returns {number}
 */
function moveTo(creep, target) {
    var result = 0;
    // Execute moves by cached paths at first
    result = creep.moveTo(target);
    return result;
}
exports.moveTo = moveTo;
/**
 * Returns true if the `ticksToLive` of a creep has dropped below the renew
 * limit set in config.
 *
 * @export
 * @param {Creep} creep
 * @returns {boolean}
 */
function needsRenew(creep) {
    return (creep.ticksToLive < Config.DEFAULT_MIN_LIFE_BEFORE_NEEDS_REFILL);
}
exports.needsRenew = needsRenew;
/**
 * Shorthand method for `renewCreep()`.
 *
 * @export
 * @param {Creep} creep
 * @param {Spawn} spawn
 * @returns {number}
 */
function tryRenew(creep, spawn) {
    return spawn.renewCreep(creep);
}
exports.tryRenew = tryRenew;
/**
 * Moves a creep to a designated renew spot (in this case the spawn).
 *
 * @export
 * @param {Creep} creep
 * @param {Spawn} spawn
 */
function moveToRenew(creep, spawn) {
    if (tryRenew(creep, spawn) === ERR_NOT_IN_RANGE) {
        creep.moveTo(spawn);
    }
}
exports.moveToRenew = moveToRenew;
/**
 * Attempts transferring available resources to the creep.
 *
 * @export
 * @param {Creep} creep
 * @param {RoomObject} roomObject
 */
function getEnergy(creep, roomObject) {
    var energy = roomObject;
    if (energy) {
        if (creep.pos.isNearTo(energy)) {
            creep.pickup(energy);
        }
        else {
            moveTo(creep, energy.pos);
        }
    }
}
exports.getEnergy = getEnergy;
/**
 * Returns true if a creep's `working` memory entry is set to true, and false
 * otherwise.
 *
 * @export
 * @param {Creep} creep
 * @returns {boolean}
 */
function canWork(creep) {
    var working = creep.memory.working;
    if (working && _.sum(_.values(creep.carry)) === 0) {
        creep.memory.working = false;
        return false;
    }
    else if (!working && _.sum(_.values(creep.carry)) === creep.carryCapacity) {
        creep.memory.working = true;
        return true;
    }
    else {
        return creep.memory.working;
    }
}
exports.canWork = canWork;
