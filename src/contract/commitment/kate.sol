// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./pairing.sol";

library Kate {
    uint256 constant baby_jubjub_p =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;

    /**
     * Evaluates a polynomial at a given point.
     * @param coefficients The coefficients of the polynomial.
     * @param index The index at which to evaluate the polynomial.
     */
    function eval(
        uint256[] memory coefficients,
        uint256 index
    ) public pure returns (uint256) {
        uint256 m = baby_jubjub_p;
        uint256 result = 0;
        uint256 power = 1;
        for (uint256 i = 0; i < coefficients.length; i++) {
            uint256 coeff = coefficients[i];
            assembly {
                result := addmod(result, mulmod(power, coeff, m), m)
                power := mulmod(power, index, m)
            }
        }
        return result;
    }

    /**
     * Verifies that a single-point evaluation of a polynomial is valid using the KZG commitment scheme.
     */
    function verifySinglePoint(
        Pairing.G1Point memory commitment,
        Pairing.G1Point memory proof,
        uint256 index,
        uint256 value
    ) public view returns (bool) {
        // make sure that each parameter is less than the prime
        require(
            commitment.x < baby_jubjub_p,
            "[KZG]: commitment.x is out of range."
        );
        require(
            commitment.y < baby_jubjub_p,
            "[KZG]: commitment.y is out of range."
        );
        require(proof.x < baby_jubjub_p, "[KZG]: proof.x is out of range.");
        require(proof.y < baby_jubjub_p, "[KZG]: proof.y is out of range.");
        require(index < baby_jubjub_p, "[KZG]: index is out of range.");
        require(value < baby_jubjub_p, "[KZG]: value is out of range.");

        Pairing.G1Point memory G10 = Pairing.G1Point({
            x: 0x0000000000000000000000000000000000000000000000000000000000000001,
            y: 0x0000000000000000000000000000000000000000000000000000000000000002
        });
        Pairing.G2Point memory G20 = Pairing.G2Point({
            x: [
                0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2,
                0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed
            ],
            y: [
                0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b,
                0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa
            ]
        });
        Pairing.G2Point memory G21 = Pairing.G2Point({
            x: [
                0x21a808dad5c50720fb7294745cf4c87812ce0ea76baa7df4e922615d1388f25a,
                0x04c5e74c85a87f008a2feb4b5c8a1e7f9ba9d8eb40eb02e70139c89fb1c505a9
            ],
            y: [
                0x204b66d8e1fadc307c35187a6b813be0b46ba1cd720cd1c4ee5f68d13036b4ba,
                0x2d58022915fc6bc90e036e858fbc98055084ac7aff98ccceb0e3fde64bc1a084
            ]
        });
        Pairing.G1Point memory commitment_minus_a = Pairing.add(
            commitment,
            Pairing.negate(Pairing.mul(G10, value))
        );
        Pairing.G1Point memory neg_proof = Pairing.negate(proof);
        Pairing.G1Point memory index_mul_proof = Pairing.mul(proof, index);

        return
            Pairing.pairing2(
                Pairing.add(index_mul_proof, commitment_minus_a),
                G20,
                neg_proof,
                G21
            );
    }
}
