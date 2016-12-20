"use strict";
var log_levels_1 = require("../components/support/log.levels");
/**
 * Enable this if you want a lot of text to be logged to console.
 * @type {boolean}
 */
exports.ENABLE_DEBUG_MODE = true;
/**
 * Enable this to use the experimental PathFinder class.
 */
exports.USE_PATHFINDER = true;
/**
 * Minimum number of ticksToLive for a Creep before they go to renew.
 * @type {number}
 */
exports.DEFAULT_MIN_LIFE_BEFORE_NEEDS_REFILL = 700;
/**
 * Debug level for log output
 */
exports.LOG_LEVEL = log_levels_1.LogLevels.DEBUG;
/**
 * Prepend log output with current tick number.
 */
exports.LOG_PRINT_TICK = true;
/**
 * Prepend log output with source line.
 */
exports.LOG_PRINT_LINES = true;
/**
 * Load source maps and resolve source lines back to typeascript.
 */
exports.LOG_LOAD_SOURCE_MAP = true;
/**
 * Maximum padding for source links (for aligning log output).
 */
exports.LOG_MAX_PAD = 100;
/**
 * VSC location, used to create links back to source.
 * Repo and revision are filled in at build time for git repositories.
 */
exports.LOG_VSC = { repo: "@@_repo_@@", revision: "@@_revision_@@", valid: false };
/**
 * URL template for VSC links, this one works for github and gitlab.
 */
exports.LOG_VSC_URL_TEMPLATE = function (path, line) {
    return exports.LOG_VSC.repo + "/blob/" + exports.LOG_VSC.revision + "/" + path + "#" + line;
};
