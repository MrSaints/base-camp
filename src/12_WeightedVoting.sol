// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh();
    error AlreadyVoted();
    error VotingClosed();

    uint private maxSupply = 1_000_000;

    struct Issue {
        EnumerableSet.AddressSet voters;

        string issueDesc;
        uint quorum;

        uint totalVotes;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;

        bool passed;
        bool closed;
    }

    struct FormattedIssue {
        address[] voters;

        string issueDesc;
        uint quorum;

        uint totalVotes;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;

        bool passed;
        bool closed;
    }

    Issue[] private issues;

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    mapping(address => bool) private claimed;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        issues.push();
        Issue storage burntIssue = issues[issues.length - 1];
        burntIssue.issueDesc = "burnt";
        burntIssue.closed = true;
    }

    function claim() external {
        if (claimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (maxSupply == totalSupply()) {
            revert AllTokensClaimed();
        }
        claimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    function createIssue(string calldata _issueDesc, uint _quorum) external returns (uint) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh();
        }
        issues.push();
        Issue storage newIssue = issues[issues.length - 1];
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        return issues.length - 1;
    }

    function getIssue(uint _id) external view returns (FormattedIssue memory) {
        Issue storage issue = issues[_id];
        address[] memory voters = new address[](issue.voters.length());
        for(uint i; i < issue.voters.length(); i++) {
            voters[i] = issue.voters.at(i);
        }

        return FormattedIssue({
            voters: voters,
            issueDesc: issue.issueDesc,
            quorum: issue.quorum,
            totalVotes: issue.totalVotes,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            passed: issue.passed,
            closed: issue.closed
        });
    }

    function vote(uint _issueId, Vote _vote) external {
        Issue storage issue = issues[_issueId];

        if (issue.closed) {
            revert VotingClosed();
        }
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        issue.voters.add(msg.sender);

        if (_vote == Vote.AGAINST) {
            issue.votesAgainst += balanceOf(msg.sender);
        } else if (_vote == Vote.FOR) {
            issue.votesFor += balanceOf(msg.sender);
        } else {
            issue.votesAbstain += balanceOf(msg.sender);
        }
        issue.totalVotes += balanceOf(msg.sender);

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
