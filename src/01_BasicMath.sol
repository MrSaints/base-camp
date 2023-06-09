// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract BasicMath {
    function adder(uint _a, uint _b) external pure returns (uint sum, bool error) {
        unchecked {
            uint _c = _a + _b;
            if (_c < _a) {
                return (0, true);
            }
            return (_c, false);
        }
    }

    function subtractor(uint _a, uint _b) external pure returns (uint difference, bool error) {
        if (_b > _a) {
            return (0, true);
        }
        unchecked {
            return (_a - _b, false);
        }
    }
}
