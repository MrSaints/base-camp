// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/05_FavoriteRecords.sol";

contract FavoriteRecordsTest is Test {
    FavoriteRecords public favoriteRecords;
    string[] private _expectedApprovedRecords;

    function setUp() public {
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

        _expectedApprovedRecords = _approvedRecordsToLoad;
        favoriteRecords = new FavoriteRecords(_approvedRecordsToLoad);
    }

    function testGetApprovedRecords() public {
        string[] memory _approvedRecords = favoriteRecords.getApprovedRecords();
        assertEq(_approvedRecords.length, _expectedApprovedRecords.length);
        for (uint i = 0; i < _expectedApprovedRecords.length; i++) {
            assertEq(_approvedRecords[i], _expectedApprovedRecords[i]);
        }
    }

    function testGetUserFavorites() public {
        favoriteRecords.resetUserFavorites();
        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        favoriteRecords.resetUserFavorites();

        favoriteRecords.addRecord("Thriller");
        favoriteRecords.addRecord("Back in Black");

        string[] memory userFavorites = favoriteRecords.getUserFavorites(address(this));
        assertEq(userFavorites.length, 2);
        assertEq(userFavorites[0], "Thriller");
        assertEq(userFavorites[1], "Back in Black");

        vm.expectRevert(abi.encodeWithSelector(FavoriteRecords.NotApproved.selector, "Celebrate"));
        favoriteRecords.addRecord("Celebrate");

        vm.startPrank(0xba5E00000000000000000000000000000000ba5e);
        favoriteRecords.addRecord("Rumours");
        favoriteRecords.addRecord("Saturday Night Fever");

        userFavorites = favoriteRecords.getUserFavorites(address(0xba5E00000000000000000000000000000000ba5e));
        assertEq(userFavorites.length, 2);
        assertEq(userFavorites[0], "Rumours");
        assertEq(userFavorites[1], "Saturday Night Fever");
        vm.stopPrank();

        favoriteRecords.resetUserFavorites();
        assertEq(favoriteRecords.getUserFavorites(address(this)).length, 0);
    }
}