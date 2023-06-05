// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/07_Inheritance.sol";

// forge script script/07_Inheritance.s.sol:DeployInheritance --broadcast --verify --rpc-url base-goerli
contract DeployInheritance is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        Salesperson salesperson = new Salesperson(
            55_555,
            12_345,
            20
        );
        EngineeringManager engineeringManager = new EngineeringManager(
            54_321,
            11_111,
            200_000
        );
        new InheritanceSubmission(address(salesperson), address(engineeringManager));
        vm.stopBroadcast();
    }
}
