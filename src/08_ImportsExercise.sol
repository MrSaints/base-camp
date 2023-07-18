// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./utils/SillyStringUtils.sol";

contract ImportsExercise {
    using SillyStringUtils for string;

    SillyStringUtils.Haiku public haiku;

    function saveHaiku(
        string calldata _line1,
        string calldata _line2,
        string calldata _line3
    ) external {
        /*
            Cheaper than doing:

                haiku = SillyStringUtils.Haiku(
                    _line1,
                    _line2,
                    _line3
                );
         */

        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    function getHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    function shruggieHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return SillyStringUtils.Haiku(
            haiku.line1,
            haiku.line2,
            haiku.line3.shruggie()
        );
    }
}
