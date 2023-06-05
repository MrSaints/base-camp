// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract FavoriteRecords {
    error NotApproved(string albumName);

    mapping(string => bool) public approvedRecords;
    string[] private _approvedRecordNames;

    mapping(address => string[]) private _userFavorites;

    constructor(string[] memory _approvedRecords) {
        for (uint i; i < _approvedRecords.length; i++) {
            approvedRecords[_approvedRecords[i]] = true;
            _approvedRecordNames.push(_approvedRecords[i]);
        }
    }

    function getApprovedRecords() external view returns (string[] memory) {
        return _approvedRecordNames;
    }

    function addRecord(string calldata _albumName) external {
        if (approvedRecords[_albumName]) {
            _userFavorites[msg.sender].push(_albumName);
        } else {
            revert NotApproved(_albumName);
        }
    }

    function getUserFavorites(address _address) external view returns (string[] memory) {
        return _userFavorites[_address];
    }

    function resetUserFavorites() external {
        delete _userFavorites[msg.sender];
    }
}
