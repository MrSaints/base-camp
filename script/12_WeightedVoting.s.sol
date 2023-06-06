// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/12_WeightedVoting.sol";

// forge script script/12_WeightedVoting.s.sol:DeployWeightedVoting --broadcast --verify --rpc-url base-goerli
contract DeployWeightedVoting is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        new WeightedVoting("Test Weighted Voting", "TESTWV");
        vm.stopBroadcast();
    }
}
