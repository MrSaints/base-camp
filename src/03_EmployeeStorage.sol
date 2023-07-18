// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract EmployeeStorage {
    error TooManyShares(uint _updatedShares);

    uint16 private shares;  // 2 bytes
    uint24 private salary;  // 3 bytes

    uint256 public idNumber;  // 32 bytes
    string public name;  // dynamically sized

    constructor(uint16 _shares, string memory _name, uint24 _salary, uint256 _idNumber)  {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }

    function viewSalary() external view returns (uint24) {
        return salary;
    }

    function viewShares() external view returns (uint16) {
        return shares;
    }

    function grantShares(uint16 _newShares) external {
        require(_newShares < 5001, "Too many shares");
        uint16 _updatedShares = shares + _newShares;
        if (_updatedShares > 5000) {
            revert TooManyShares(_updatedShares);
        }
        shares = _updatedShares;
    }

    /**
    * Do not modify this function.  It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by you wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }
}
