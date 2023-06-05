// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/08_ImportsExercise.sol";
import "../src/utils/SillyStringUtils.sol";

contract ImportsExerciseTest is Test {
    ImportsExercise public importsExercise;

    function setUp() public {
        importsExercise = new ImportsExercise();
    }

    function testShruggieHaiku() public {
        importsExercise.saveHaiku(
            "I don't have the time",
            "To write a good haiku here",
            "So much more to teach!"
        );

        SillyStringUtils.Haiku memory modified = importsExercise.shruggieHaiku();
        assertEq(modified.line1, "I don't have the time");
        assertEq(modified.line2, "To write a good haiku here");
        assertEq(modified.line3, unicode"So much more to teach! 🤷");

        SillyStringUtils.Haiku memory original = importsExercise.getHaiku();
        assertEq(original.line1, "I don't have the time");
        assertEq(original.line2, "To write a good haiku here");
        assertEq(original.line3, "So much more to teach!");
    }
}