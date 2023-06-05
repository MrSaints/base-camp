// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract employee {
    uint public idNumber;
    uint public managerId;

    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() external view virtual returns (uint);
}

contract Salaried is employee {
    uint public annualSalary;

    constructor(uint _idNumber, uint _managerId, uint _annualSalary) employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() external view override returns (uint) {
        return annualSalary;
    }
}

contract Hourly is employee {
    uint public hourlyRate;

    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() external view override returns (uint) {
        return hourlyRate * 2080;
    }
}

contract Manager {
    uint[] public employeeIds;

    function addReport(uint _employeeId) external {
        employeeIds.push(_employeeId);
    }

    function resetReports() external {
        employeeIds = new uint[](0);
    }
}

contract Salesperson is Hourly {
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) Hourly(_idNumber, _managerId, _hourlyRate) {
        // no-op
    }   
}

contract EngineeringManager is Salaried, Manager {
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) Salaried(_idNumber, _managerId, _annualSalary) {
        // no-op
    }
}

contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
