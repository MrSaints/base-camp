// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/04_ArraysExercise.sol";

contract ArraysExerciseTest is Test {
    ArraysExercise public arraysExercise;

    function setUp() public {
        arraysExercise = new ArraysExercise();
    }

    function testAppendToNumbers() public {
        arraysExercise.resetNumbers();

        uint[] memory toAppend = new uint[](4);
        toAppend[0] = 11;
        toAppend[1] = 12;
        toAppend[2] = 13;
        toAppend[3] = 14;
        arraysExercise.appendToNumbers(toAppend);

        uint[14] memory expectedNumbers = [
            uint(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
        ];
        uint[] memory expected = new uint[](14);
        for (uint i = 0; i < expected.length; i++) {
            expected[i] = expectedNumbers[i];
        }
        assertEq(arraysExercise.getNumbers(), expected);
    }

    function testAfterY2K() public {
        arraysExercise.resetSenders();
        arraysExercise.resetTimestamps();

        arraysExercise.saveTimestamp(946702600);
        arraysExercise.saveTimestamp(946702700);
        arraysExercise.saveTimestamp(946702900);

        vm.startPrank(0xba5E00000000000000000000000000000000ba5e);
        arraysExercise.saveTimestamp(946702650);
        arraysExercise.saveTimestamp(946702950);
        vm.stopPrank();

        (
            uint[] memory timestamps,
            address[] memory senders
        ) = arraysExercise.afterY2K();

        uint[] memory expectedTimestamps = new uint[](2);
        expectedTimestamps[0] = 946702900;
        expectedTimestamps[1] = 946702950;
        assertEq(timestamps, expectedTimestamps);

        address[] memory expectedSenders = new address[](2);
        expectedSenders[0] = address(this);
        expectedSenders[1] = address(0xba5E00000000000000000000000000000000ba5e);
        assertEq(senders, expectedSenders);
    }
}
