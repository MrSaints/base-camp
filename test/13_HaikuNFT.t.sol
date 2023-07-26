// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/13_HaikuNFT.sol";

contract HaikuNFTTest is Test {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    HaikuNFT public token;

    function setUp() public {
        token = new HaikuNFT("Test Haiku NFT", "TESTHAIKU");
    }

    function testMintHaiku() public {
        assertEq(token.counter(), 1);
        assertEq(token.balanceOf(address(this)), 0);
        vm.expectEmit();
        emit Transfer(address(0), address(this), 1);
        token.mintHaiku(
            "Code as law takes flight",
            "Trust in blockchain's steady light",
            "Deals sealed in bytes, right."
        );
        assertEq(token.balanceOf(address(this)), 1);
        assertEq(token.ownerOf(token.counter() - 1), address(this));
    }

    function testMintHaikuExisting() public {
        token.mintHaiku(
            "Code as law takes flight",
            "Trust in blockchain's steady light",
            "Deals sealed in bytes, right."
        );

        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        vm.expectRevert(abi.encodeWithSelector(HaikuNFT.HaikuNotUnique.selector));
        token.mintHaiku(
            "Ledger's pact gleams bright",
            "In blockchain's immutable night",
            "Deals sealed in bytes, right."
        );
    }

    function testShareHaiku() public {
        token.mintHaiku(
            "In digital chains, bound",
            "Deals strike with a silent sound",
            "Trust in code is found"
        );

        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        vm.expectRevert(abi.encodeWithSelector(HaikuNFT.NoHaikusShared.selector));
        token.getMySharedHaikus();

        token.shareHaiku(1, address(0xba5E00000000000000000000000000000000ba5e));

        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        HaikuNFT.Haiku[] memory sharedHaikus = token.getMySharedHaikus();
        assertEq(sharedHaikus.length, 1);
        assertEq(sharedHaikus[0].line1, "In digital chains, bound");
        assertEq(sharedHaikus[0].line2, "Deals strike with a silent sound");
        assertEq(sharedHaikus[0].line3, "Trust in code is found");

        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        vm.expectRevert(abi.encodeWithSelector(HaikuNFT.NotHaikuOwner.selector));
        token.shareHaiku(1, address(0xba5E000000000000000000000000000000000002));
    }
}