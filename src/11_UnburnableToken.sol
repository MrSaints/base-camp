// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract UnburnableToken {
    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address);

    uint public totalSupply;
    uint public totalClaimed;
    mapping(address => uint) public balances;

    mapping(address => bool) private claimed;

    constructor() {
        totalSupply = 100_000_000;
    }

    function claim() external {
        if (claimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (totalClaimed + 1000 > totalSupply) {
            revert AllTokensClaimed();
        }

        claimed[msg.sender] = true;
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
    }

    function safeTransfer(address _to, uint amount) external {
        if (_to == address(0) || _to.balance == 0 || balances[msg.sender] < amount) {
            revert UnsafeTransfer(_to);
        }

        balances[msg.sender] -= amount;
        balances[_to] += amount;
    }

    // For testing
    function _setTotalSupply(uint _totalSupply) external {
        totalSupply = _totalSupply;
    }
}