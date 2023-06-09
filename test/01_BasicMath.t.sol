// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/01_BasicMath.sol";

contract BasicMathTest is Test {
    BasicMath public basicMath;

    function setUp() public {
        basicMath = new BasicMath();
    }

    function test1Plus2() public {
        (uint res, bool err) = basicMath.adder(1, 2);

        assertEq(res, 3);
        assertFalse(err);
    }

    function testPlusZero() public {
        (uint res, bool err) = basicMath.adder(0, 0);

        assertEq(res, 0);
        assertFalse(err);
    }

    function test1PlusMaxInt() public {
        (uint res, bool err) = basicMath.adder(1, type(uint).max);

        assertEq(res, 0);
        assertTrue(err);

        (res, err) = basicMath.adder(type(uint).max, 1);

        assertEq(res, 0);
        assertTrue(err);
    }

    function test2Minus1() public {
        (uint res, bool err) = basicMath.subtractor(2, 1);

        assertEq(res, 1);
        assertFalse(err);
    }

    function testMinusZero() public {
        (uint res, bool err) = basicMath.subtractor(0, 0);

        assertEq(res, 0);
        assertFalse(err);
    }

    function test1Minus2() public {
        (uint res, bool err) = basicMath.subtractor(1, 2);

        assertEq(res, 0);
        assertTrue(err);
    }
}
