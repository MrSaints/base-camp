// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/10_NewExercise.sol";

// ETHERSCAN_API_KEY=noop forge script script/10_NewExercise.s.sol:DeployNewExercise --broadcast --verify --rpc-url base-goerli
contract DeployNewExercise is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        new AddressBookFactory();
        vm.stopBroadcast();
    }
}
