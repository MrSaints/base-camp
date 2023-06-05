// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    /**
     * Finds the difference between each uint with it's neighbor (a to b, b to c, etc.)
     * and returns a uint array with the absolute integer difference of each pairing.
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        uint[] memory results = new uint[](3);

        results[0] = (_a > _b) ? _a - _b : _b - _a;
        results[1] = (_b > _c) ? _b - _c : _c - _b;
        results[2] = (_c > _d) ? _c - _d : _d - _c;

        return results;
    }

    /**
     * Changes the _base by the value of _modifier.  Base is always > 1000.  Modifiers can be
     * between positive and negative 100;
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        if (_modifier > 0) {
            return _base + uint(_modifier);
        }
        return _base - uint(-_modifier);
    }

    /**
     * Pop the last element from the supplied array, and return the modified array and the popped
     * value (unlike the built-in function)
     */
    uint[] arr;

    function popWithReturn() public returns (uint) {
        uint value = arr[arr.length - 1];
        arr.pop();
        return value;
    }

    // The utility functions below are working as expected
    function addToArr(uint _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}
