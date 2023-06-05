// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/02_ControlStructures.sol";

contract ControlStructuresTest is Test {
    ControlStructures public controlStructures;

    function setUp() public {
        controlStructures = new ControlStructures();
    }

    function testFizzBuzz() public {
        assertEq(controlStructures.fizzBuzz(9), "Fizz");
        assertEq(controlStructures.fizzBuzz(10), "Buzz");
        assertEq(controlStructures.fizzBuzz(15), "FizzBuzz");
        assertEq(controlStructures.fizzBuzz(11), "Splat");
    }

    function testAfterHours() public {
        vm.expectRevert();
        controlStructures.doNotDisturb(2401);

        vm.expectRevert(abi.encodeWithSelector(ControlStructures.AfterHours.selector, 2201));
        controlStructures.doNotDisturb(2201);

        assertEq(controlStructures.doNotDisturb(801), "Morning!");
        assertEq(controlStructures.doNotDisturb(1450), "Afternoon!");
        assertEq(controlStructures.doNotDisturb(1830), "Evening!");
    }
}
