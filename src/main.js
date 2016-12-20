"use strict";
var CreepManager = require("./components/creeps/creepManager");
var Config = require("./config/config");
var _ = require("lodash");
var log_1 = require("./components/support/log");
// Any code written outside the `loop()` method is executed only when the
// Screeps system reloads your script.
// Use this bootstrap wisely. You can cache some of your stuff to save CPU.
// You should extend prototypes before the game loop executes here.
// This is an example for using a config variable from `config.ts`.
if (Config.USE_PATHFINDER) {
    PathFinder.use(true);
}
log_1.log.info("load");
/**
 * Screeps system expects this "loop" method in main.js to run the
 * application. If we have this line, we can be sure that the globals are
 * bootstrapped properly and the game loop is executed.
 * http://support.screeps.com/hc/en-us/articles/204825672-New-main-loop-architecture
 *
 * @export
 */
function loop() {
    var nums = [
        { "id": 1, "letter": "a" },
        { "id": 2, "letter": "b" },
        { "id": 2, "letter": "c" },
    ];
    log_1.log.info(_.sumBy(nums, function (n) { return n.id; }));
    // Check memory for null or out of bounds custom objects
    if (!Memory.uuid || Memory.uuid > 100) {
        Memory.uuid = 0;
    }
    for (var i in Game.rooms) {
        var room = Game.rooms[i];
        CreepManager.run(room);
        // Clears any non-existing creep memory.
        for (var name_1 in Memory.creeps) {
            var creep = Memory.creeps[name_1];
            if (creep.room === room.name) {
                if (!Game.creeps[name_1]) {
                    log_1.log.info("Clearing non-existing creep memory:", name_1);
                    delete Memory.creeps[name_1];
                }
            }
        }
    }
}
exports.loop = loop;
