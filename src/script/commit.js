"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
require('module-alias/register');
var assert = require("assert");
var galois = require("@guildofweavers/galois");
var ffjavascript = require("ffjavascript");
var MAX_G1_SOL_POINTS = 128;
var FIELD_SIZE = BigInt('21888242871839275222246405745257275088548364400416034343698204186575808495617');
var G1 = ffjavascript.bn128.G1;
var G2 = ffjavascript.bn128.G2;
var SRS_G1_DATA_RAW = require('@rollup/key/taug1_65536.json');
var SRS_G2_DATA_RAW = require('@rollup/key/taug2_65536.json');
function generateBabyJubjubField() {
    return galois.createPrimeField(FIELD_SIZE);
}
function generateG1SRS(depth) {
    assert(depth > 0);
    assert(depth <= 65536);
    var g1 = [];
    for (var i = 0; i < depth; i++) {
        g1.push([
            BigInt(SRS_G1_DATA_RAW[i][0]),
            BigInt(SRS_G1_DATA_RAW[i][1]),
            BigInt(1),
        ]);
    }
    assert(g1[0][0] === G1.g[0]);
    assert(g1[0][1] === G1.g[1]);
    assert(g1[0][2] === G1.g[2]);
    return g1;
}
var commit = function (coefficient) {
};
generateG1SRS(2);
