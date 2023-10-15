// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Hash {
    function hash(bytes memory data) public pure returns (bytes32) {
        return keccak256(data);
    }
}
