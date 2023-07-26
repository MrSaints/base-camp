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
        Issue storage burntIssue = issues.push();
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
        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        unchecked {
            return issues.length - 1;
        }
    }

    function getIssue(uint _id) external view returns (FormattedIssue memory) {
        Issue storage issue = issues[_id];
        return FormattedIssue({
            voters: issue.voters.values(),
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
        uint balance = balanceOf(msg.sender);
        if (balance == 0) {
            revert NoTokensHeld();
        }

        issue.voters.add(msg.sender);

        if (_vote == Vote.AGAINST) {
            issue.votesAgainst += balance;
        } else if (_vote == Vote.FOR) {
            issue.votesFor += balance;
        } else {
            issue.votesAbstain += balance;
        }
        issue.totalVotes += balance;

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
