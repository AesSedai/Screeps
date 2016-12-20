"use strict";
var Config = require("../../config/config");
var _ = require("lodash");
var harvester = require("./roles/harvester");
var log_1 = require("../support/log");
exports.creepCount = 0;
exports.harvesters = [];
/**
 * Initialization scripts for CreepManager module.
 *
 * @export
 * @param {Room} room
 */
function run(room) {
    _loadCreeps(room);
    _buildMissingCreeps(room);
    _.each(exports.creeps, function (creep) {
        if (creep.memory.role === "harvester") {
            harvester.run(creep);
        }
    });
}
exports.run = run;
/**
 * Loads and counts all available creeps.
 *
 * @param {Room} room
 */
function _loadCreeps(room) {
    exports.creeps = room.find(FIND_MY_CREEPS);
    exports.creepCount = _.size(exports.creeps);
    // Iterate through each creep and push them into the role array.
    exports.harvesters = _.filter(exports.creeps, function (creep) { return creep.memory.role === "harvester"; });
    if (Config.ENABLE_DEBUG_MODE) {
        log_1.log.info(exports.creepCount + " creeps found in the playground.");
    }
}
/**
 * Creates a new creep if we still have enough space.
 *
 * @param {Room} room
 */
function _buildMissingCreeps(room) {
    var bodyParts;
    var spawns = room.find(FIND_MY_SPAWNS, {
        filter: function (spawn) {
            return spawn.spawning === null;
        },
    });
    if (Config.ENABLE_DEBUG_MODE) {
        if (spawns[0]) {
            log_1.log.info("Spawn: " + spawns[0].name);
        }
    }
    if (exports.harvesters.length < 2) {
        if (exports.harvesters.length < 1 || room.energyCapacityAvailable <= 800) {
            bodyParts = [WORK, WORK, CARRY, MOVE];
        }
        else if (room.energyCapacityAvailable > 800) {
            bodyParts = [WORK, WORK, WORK, WORK, CARRY, CARRY, MOVE, MOVE];
        }
        _.each(spawns, function (spawn) {
            _spawnCreep(spawn, bodyParts, "harvester");
        });
    }
}
/**
 * Spawns a new creep.
 *
 * @param {Spawn} spawn
 * @param {string[]} bodyParts
 * @param {string} role
 * @returns
 */
function _spawnCreep(spawn, bodyParts, role) {
    var uuid = Memory.uuid;
    var status = spawn.canCreateCreep(bodyParts, undefined);
    var properties = {
        role: role,
        room: spawn.room.name,
    };
    status = _.isString(status) ? OK : status;
    if (status === OK) {
        Memory.uuid = uuid + 1;
        var creepName = spawn.room.name + " - " + role + uuid;
        log_1.log.info("Started creating new creep: " + creepName);
        if (Config.ENABLE_DEBUG_MODE) {
            log_1.log.info("Body: " + bodyParts);
        }
        status = spawn.createCreep(bodyParts, creepName, properties);
        return _.isString(status) ? OK : status;
    }
    else {
        if (Config.ENABLE_DEBUG_MODE) {
            log_1.log.info("Failed creating new creep: " + status);
        }
        return status;
    }
}
