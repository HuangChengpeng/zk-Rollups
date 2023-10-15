require('module-alias/register')
import * as assert from 'assert'
import * as galois from '@guildofweavers/galois'
import * as bn128 from 'rustbn.js'
import * as ffjavascript from 'ffjavascript'
import { ec } from 'elliptic'

type G1Point = ec
type G2Point = ec
type Coefficient = bigint
type Polynomial = Coefficient[]
type Commitment = G1Point
type Proof = G1Point
type MultiProof = G2Point

interface PairingInputs {
    g1: G1Point;
    g2: G2Point;
}

const MAX_G1_SOL_POINTS = 128
const FIELD_SIZE = BigInt('21888242871839275222246405745257275088548364400416034343698204186575808495617')

const G1 = ffjavascript.bn128.G1
const G2 = ffjavascript.bn128.G2

const SRS_G1_DATA_RAW = require('@rollup/key/taug1_65536.json')
const SRS_G2_DATA_RAW = require('@rollup/key/taug2_65536.json')

function generateBabyJubjubField() {
    return galois.createPrimeField(FIELD_SIZE)
}

function generateG1SRS(depth: number): G1Point[] {
    assert(depth > 0)
    assert(depth <= 65536)

    const g1: G1Point[] = []
    for (let i = 0; i < depth; i++) {
        g1.push([
            BigInt(SRS_G1_DATA_RAW[i][0]),
            BigInt(SRS_G1_DATA_RAW[i][1]),
            BigInt(1),
        ])
    }

    assert(g1[0][0] === G1.g[0])
    assert(g1[0][1] === G1.g[1])
    assert(g1[0][2] === G1.g[2])

    return g1
}

const commit = (coefficient: Coefficient): Commitment => {
    
}

generateG1SRS(2)
