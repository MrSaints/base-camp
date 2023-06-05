// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/11_UnburnableToken.sol";

// forge script script/11_UnburnableToken.s.sol:DeployUnburnableToken --broadcast --verify --rpc-url base-goerli
contract DeployUnburnableToken is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        new UnburnableToken();
        vm.stopBroadcast();
    }
}
