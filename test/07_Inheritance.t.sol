// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/07_Inheritance.sol";

interface IEmployee {
    function idNumber() external returns (uint);
    function managerId() external returns (uint);
}
interface ISalaried is IEmployee {
    function annualSalary() external returns (uint);
}
interface IHourly is IEmployee {
    function hourlyRate() external returns (uint);
}

interface ISalesPerson is IHourly {}
interface IEngineeringManager is ISalaried {}

interface IInheritanceSubmission {
    function salesPerson() external returns (address);
    function engineeringManager() external returns (address);
}

contract InheritanceTest is Test {
    IInheritanceSubmission public submission;

    function setUp() public {
        Salesperson salesperson = new Salesperson(
            55_555,
            12_345,
            20
        );
        EngineeringManager engineeringManager = new EngineeringManager(
            54_321,
            11_111,
            200_000
        );
        submission = IInheritanceSubmission(address(
            new InheritanceSubmission(address(salesperson), address(engineeringManager))
        ));
    }

    function testSalesPersonHourlyRate() public {
        assertEq(ISalesPerson(submission.salesPerson()).hourlyRate(), 20);
    }

    function testSalesPersonIdNumber() public {
        assertEq(ISalesPerson(submission.salesPerson()).idNumber(), 55_555);
    }

    function testSalesPersonManagerId() public {
        assertEq(ISalesPerson(submission.salesPerson()).managerId(), 12_345);
    }

    function testEngineeringManagerAnnualSalary() public {
        assertEq(IEngineeringManager(submission.engineeringManager()).annualSalary(), 200_000);
    }

    function testEngineeringManagerIdNumber() public {
        assertEq(IEngineeringManager(submission.engineeringManager()).idNumber(), 54_321);
    }

    function testEngineeringManagerManagerId() public {
        assertEq(IEngineeringManager(submission.engineeringManager()).managerId(), 11_111);
    }
}