// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/05_FavoriteRecords.sol";

// forge script script/05_FavoriteRecords.s.sol:DeployFavoriteRecords --broadcast --verify --rpc-url base-goerli
contract DeployFavoriteRecords is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.envString("MNEMONIC");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        string[] memory _approvedRecordsToLoad = new string[](9);
        _approvedRecordsToLoad[0] = "Thriller";
        _approvedRecordsToLoad[1] = "Back in Black";
        _approvedRecordsToLoad[2] = "The Bodyguard";
        _approvedRecordsToLoad[3] = "The Dark Side of the Moon";
        _approvedRecordsToLoad[4] = "Their Greatest Hits (1971-1975)";
        _approvedRecordsToLoad[5] = "Hotel California";
        _approvedRecordsToLoad[6] = "Come On Over";
        _approvedRecordsToLoad[7] = "Rumours";
        _approvedRecordsToLoad[8] = "Saturday Night Fever";
        new FavoriteRecords(_approvedRecordsToLoad);
        vm.stopBroadcast();
    }
}
