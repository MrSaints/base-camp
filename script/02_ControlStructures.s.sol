// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/02_ControlStructures.sol";

// forge script script/02_ControlStructures.s.sol:DeployControlStructures --broadcast --verify --rpc-url base-goerli
contract DeployControlStructures is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        new ControlStructures();
        vm.stopBroadcast();
    }
}
