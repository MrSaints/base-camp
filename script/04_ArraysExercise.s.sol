// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/04_ArraysExercise.sol";

// ETHERSCAN_API_KEY=noop forge script script/04_ArraysExercise.s.sol:DeployArraysExercise --broadcast --verify --rpc-url base-goerli
contract DeployArraysExercise is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        new ArraysExercise();
        vm.stopBroadcast();
    }
}
