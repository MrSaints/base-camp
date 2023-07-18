// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract FavoriteRecords {
    error NotApproved(string albumName);

    mapping(string => bool) public approvedRecords;
    // Can be immutable if we do not intend on changing it.
    string[] private approvedRecordNames;

    mapping(address => string[]) private userFavorites;

    constructor(string[] memory _approvedRecords) {
        for (uint i; i < _approvedRecords.length;) {
            approvedRecords[_approvedRecords[i]] = true;
            approvedRecordNames.push(_approvedRecords[i]);
            unchecked {
                ++i;
            }
        }
    }

    function getApprovedRecords() external view returns (string[] memory) {
        return approvedRecordNames;
    }

    function addRecord(string calldata _albumName) external {
        if (!approvedRecords[_albumName]) {
            revert NotApproved(_albumName);
        }
        userFavorites[msg.sender].push(_albumName);
    }

    function getUserFavorites(address _address) external view returns (string[] memory) {
        return userFavorites[_address];
    }

    function resetUserFavorites() external {
        delete userFavorites[msg.sender];
    }
}
