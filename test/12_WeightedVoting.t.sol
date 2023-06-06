// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/12_WeightedVoting.sol";

contract WeightedVotingTest is Test {
    WeightedVoting public token;

    function setUp() public {
        token = new WeightedVoting("Test Weighted Voting", "TESTWV");
    }

    function testTokenClaim() public {
        assertEq(token.totalSupply(), 0);
        token.claim();
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.TokensClaimed.selector));
        token.claim();
        assertEq(token.totalSupply(), 100);
        assertEq(token.balanceOf(address(this)), 100);

        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        token.claim();
        assertEq(token.totalSupply(), 200);
        assertEq(token.balanceOf(address(this)), 100);
    }

    function testVoting() public {
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.NoTokensHeld.selector));
        token.createIssue("Testing", 300);
    
        token.claim();
        
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.QuorumTooHigh.selector));
        token.createIssue("Testing", 300);

        vm.prank(0xba5E000000000000000000000000000000000002);
        token.claim();
        vm.prank(0xba5E000000000000000000000000000000000003);
        token.claim();
        vm.prank(0xba5e000000000000000000000000000000000005);
        token.claim();

        uint _issueId = token.createIssue("Testing", 300);

        // 100 FOR
        vm.startPrank(0xba5E000000000000000000000000000000000002);
        token.vote(_issueId, WeightedVoting.Vote.FOR);
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.AlreadyVoted.selector));
        token.vote(_issueId, WeightedVoting.Vote.FOR);
        vm.stopPrank();

        // 50 AGAINST
        vm.startPrank(0xba5E000000000000000000000000000000000003);
        token.transfer(0xba5E000000000000000000000000000000000004, 50);
        token.vote(_issueId, WeightedVoting.Vote.AGAINST);
        vm.stopPrank();

        // 50 ABSTAIN
        vm.prank(0xba5E000000000000000000000000000000000004);
        token.vote(_issueId, WeightedVoting.Vote.ABSTAIN);

        // 100 ABSTAIN
        vm.prank(0xba5e000000000000000000000000000000000005);
        token.vote(_issueId, WeightedVoting.Vote.ABSTAIN);

        WeightedVoting.FormattedIssue memory issue = token.getIssue(_issueId);
        assertEq(issue.voters.length, 4);
        assertEq(issue.issueDesc, "Testing");
        assertEq(issue.totalVotes, 300);
        assertTrue(issue.closed);
        assertTrue(issue.passed);
    }
}
