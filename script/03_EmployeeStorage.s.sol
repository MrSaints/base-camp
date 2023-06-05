// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/03_EmployeeStorage.sol";

// forge script script/03_EmployeeStorage.s.sol:DeployEmployeeStorage --broadcast --verify --rpc-url base-goerli
contract DeployEmployeeStorage is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        new EmployeeStorage(
            1000,
            "Pat",
            50000,
            112358132134
        );
        vm.stopBroadcast();
    }
}
