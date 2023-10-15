// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

library Pairing {
    struct G1Point {
        uint256 x;
        uint256 y;
    }

    struct G2Point {
        uint256[2] x;
        uint256[2] y;
    }

    /// @return G2Point the generator of G1
    function P1() internal pure returns (G1Point memory) {
        return G1Point({x: 1, y: 2});
    }

    /// @return G2Point the generator of G2 
    function P2() internal pure returns (G2Point memory) {
        return
            G2Point({
                x: [
                    11559732032986387107991004021392285783925812861821192530917403151452391805634,
                    10857046999023057135944570762232829481370756359578518086990519993285655852781
                ],
                y: [
                    4082367875863433681332203403145435568316851327593401208105741076214120093531,
                    8495653923123431417604973247489272438418190587263600148770280649306958101930
                ]
            });
    }

    /// @return G1Point the negation of point p in G1, i.e., p.add(p.negate()) should be zero.
    function negate(G1Point memory p) internal pure returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint256 q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.x == 0 && p.y == 0) return G1Point({x: 0, y: 0});
        return G1Point({x: p.x, y: q - (p.y % q)});
    }

    /// @return r the sum of two points of G1
    function add(
        G1Point memory p1,
        G1Point memory p2
    ) internal view returns (G1Point memory r) {
        uint256[4] memory input;
        input[0] = p1.x;
        input[1] = p1.y;
        input[2] = p2.x;
        input[3] = p2.y;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60) // Use "sub" to subtract from gas left (must use staticcall).
            // This saves 3 gas.
            switch success
            case 0 {
                invalid()
            }
        }
        require(success, "[pairing]: invalid addition!");
    }

    /// @return r the product of a point on G1 and a scalar, i.e., p == p.mul(1) and p.add(p) == p.mul(2) for all points p.
    function mul(
        G1Point memory p,
        uint256 s
    ) internal view returns (G1Point memory r) {
        uint256[3] memory input;
        input[0] = p.x;
        input[1] = p.y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60) // Use "sub" to subtract from gas left (must use staticcall).
            // This saves 3 gas.
            switch success
            case 0 {
                invalid()
            }
        }
        require(success, "[pairing]: invalid multiplication!");
    }

    /// @return bool whether or not the provided point is on the elliptic curve.
    function isOnCurve(G1Point memory p) internal view returns (bool) {
        uint256[3] memory input;
        input[0] = p.x;
        input[1] = p.y;
        input[2] = 1;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 8, input, 0x80, input, 0x20) // Use "sub" to subtract from gas left (must use staticcall).
            // This saves 3 gas.
            switch success
            case 0 {
                invalid()
            }
        }
        return input[0] != 0;
    }

    /// @return bool whether or not the provided points are equal.
    function isEqual(
        G1Point memory p1,
        G1Point memory p2
    ) internal pure returns (bool) {
        return p1.x == p2.x && p1.y == p2.y;
    }

    /// @return bool the checking result of the pairing, i.e., e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1.
    function pairing(
        G1Point[] memory p1,
        G2Point[] memory p2
    ) internal view returns (bool) {
        require(p1.length == p2.length);
        uint256 inputSize = p1.length * 6;
        uint256[] memory input = new uint256[](inputSize);
        for (uint256 i = 0; i < p1.length; i++) {
            input[i * 6] = p1[i].x;
            input[i * 6 + 1] = p1[i].y;
            input[i * 6 + 2] = p2[i].x[0];
            input[i * 6 + 3] = p2[i].x[1];
            input[i * 6 + 4] = p2[i].y[0];
            input[i * 6 + 5] = p2[i].y[1];
        }
        uint256[1] memory out;
        bool success;
        assembly {
            success := staticcall(
                sub(gas(), 2000),
                0x08,
                add(input, 0x20),
                mul(inputSize, 0x20),
                out,
                0x20
            ) // Use "sub" to subtract from gas left (must use staticcall).
            // This saves 3 gas.
            switch success
            case 0 {
                invalid()
            }
        }
        require(success, "[pairing]: pairing check failed!");
        return out[0] != 0;
    }

    /// @return bool a shortcut for pairing checks of two pairs, i.e., e(a1, b1) * e(a2, b2) == 1.
    function pairing2(
        G1Point memory a1,
        G2Point memory a2,
        G1Point memory b1,
        G2Point memory b2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
}
