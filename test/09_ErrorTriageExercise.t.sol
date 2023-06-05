// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/09_ErrorTriageExercise.sol";

contract ErrorTriageExerciseTest is Test {
    ErrorTriageExercise public errTriageExercise;

    function setUp() public {
        errTriageExercise = new ErrorTriageExercise();
    }

    function testDiffWithNeighbor() public {
        uint[] memory diff = errTriageExercise.diffWithNeighbor(1, 2, 3, 4);
        assertEq(diff[0], 1);
        assertEq(diff[1], 1);
        assertEq(diff[2], 1);

        diff = errTriageExercise.diffWithNeighbor(9, 8, 6, 3);
        assertEq(diff[0], 1);
        assertEq(diff[1], 2);
        assertEq(diff[2], 3);

        diff = errTriageExercise.diffWithNeighbor(1_000, 1, 20_000, 50_000);
        assertEq(diff[0], 999);
        assertEq(diff[1], 19_999);
        assertEq(diff[2], 30_000);
    }

    function testApplyModifier() public {
        assertEq(errTriageExercise.applyModifier(230_604, -10), 230594);
        assertEq(errTriageExercise.applyModifier(1_000, -99), 901);
        assertEq(errTriageExercise.applyModifier(150_000, 99), 150_099);
    }

    function testPopWithReturn() public {
        errTriageExercise.resetArr();
        errTriageExercise.addToArr(8);
        errTriageExercise.addToArr(10);
        errTriageExercise.addToArr(55);

        assertEq(errTriageExercise.popWithReturn(), 55);
        assertEq(errTriageExercise.getArr().length, 2);

        assertEq(errTriageExercise.popWithReturn(), 10);
        assertEq(errTriageExercise.getArr().length, 1);

        errTriageExercise.addToArr(9);
        errTriageExercise.addToArr(10);
        errTriageExercise.addToArr(11);
        errTriageExercise.addToArr(20);
        errTriageExercise.addToArr(30);

        assertEq(errTriageExercise.popWithReturn(), 30);
        assertEq(errTriageExercise.popWithReturn(), 20);

        uint[] memory expected = new uint[](4);
        expected[0] = 8;
        expected[1] = 9;
        expected[2] = 10;
        expected[3] = 11;

        assertEq(errTriageExercise.getArr(), expected);
    }
}