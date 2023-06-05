// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/03_EmployeeStorage.sol";

contract EmployeeStorageTest is Test {
    EmployeeStorage public employeeStorage;

    function setUp() public {
        employeeStorage = new EmployeeStorage(
            1000,
            "Pat",
            50000,
            112358132134
        );
    }

    function testPublicStorage() public {
        assertEq(employeeStorage.name(), "Pat");
        assertEq(employeeStorage.idNumber(), 112358132134);
    }

    function testPrivateStorage() public {
        assertEq(employeeStorage.viewShares(), 1000);
        assertEq(employeeStorage.viewSalary(), 50000);
    }

    function testPacking() public {
        assertEq(employeeStorage.checkForPacking(3), 0);
    }

    function testGrantShares() public {
        vm.expectRevert("Too many shares");
        employeeStorage.grantShares(5001);

        employeeStorage.grantShares(1000);
        assertEq(employeeStorage.viewShares(), 2000);
    }
}
