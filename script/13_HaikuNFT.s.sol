// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/13_HaikuNFT.sol";

// forge script script/13_HaikuNFT.s.sol:DeployHaikuNFT --broadcast --verify --rpc-url base-goerli
contract DeployHaikuNFT is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        new HaikuNFT("Test Haiku NFT", "TESTHAIKU");
        vm.stopBroadcast();
    }
}
