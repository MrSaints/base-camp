// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/11_UnburnableToken.sol";

contract ZeroBalance {}

contract UnburnableTokenTest is Test {
    UnburnableToken public token;

    function setUp() public {
        token = new UnburnableToken();
    }

    function testTokenClaim() public {
        assertEq(token.totalClaimed(), 0);
        token.claim();
        assertEq(token.balances(address(this)), 1_000);
        vm.expectRevert(abi.encodeWithSelector(UnburnableToken.TokensClaimed.selector));
        token.claim();
        assertEq(token.totalClaimed(), 1_000);

        vm.startPrank(0xba5E00000000000000000000000000000000ba5e);
        assertEq(token.balances(address(0xba5E00000000000000000000000000000000ba5e)), 0);
        token.claim();
        assertEq(token.balances(address(0xba5E00000000000000000000000000000000ba5e)), 1_000);
        vm.stopPrank();

        assertEq(token.totalClaimed(), 2_000);
    }

    function testSafeTransfer() public {
        token.claim();

        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        token.claim();

        // Successful transfer
        vm.deal(address(0xba5Ed000000000000000000000000000000Ba5ED), 1);
        token.safeTransfer(address(0xba5Ed000000000000000000000000000000Ba5ED), 100);
        assertEq(token.balances(address(this)), 900);
        assertEq(token.balances(address(0xba5Ed000000000000000000000000000000Ba5ED)), 100);

        // Transfer from address with no balance
        vm.prank(0xABcD000000000000000000000000000000000000);
        vm.deal(address(this), 1);
        vm.expectRevert(
            abi.encodeWithSelector(
                UnburnableToken.UnsafeTransfer.selector,
                address(this)
            )
        );
        token.safeTransfer(address(this), 100);

        // Transfer to address with no ETH balance
        vm.expectRevert(
            abi.encodeWithSelector(
                UnburnableToken.UnsafeTransfer.selector,
                address(0xdead000000000000000000000000000000dead)
            )
        );
        token.safeTransfer(address(0xdead000000000000000000000000000000dead), 100);

        // Transfer to 0x
        vm.expectRevert(
            abi.encodeWithSelector(
                UnburnableToken.UnsafeTransfer.selector,
                address(0)
            )
        );
        token.safeTransfer(address(0), 100);
    }

    function testAllClaimed() public {
        token._setTotalSupply(2000);

        token.claim();

        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        token.claim();

        vm.prank(0xABcD000000000000000000000000000000000000);
        vm.expectRevert(abi.encodeWithSelector(UnburnableToken.AllTokensClaimed.selector));
        token.claim();
    }
}
