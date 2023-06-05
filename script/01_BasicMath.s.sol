// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/01_BasicMath.sol";

// forge script script/01_BasicMath.s.sol:DeployBasicMath --broadcast --verify --rpc-url base-goerli
contract DeployBasicMath is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        new BasicMath();
        vm.stopBroadcast();
    }
}
