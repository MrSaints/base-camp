// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract GarageManager {
    error BadCarIndex(uint _index);

    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    mapping(address => Car[]) public garage;

    function addCar(
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint _numberOfDoors
    ) external {
        garage[msg.sender].push(
            Car(
                _make,
                _model,
                _color,
                _numberOfDoors
            )
        );

    }

    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address _user) external view returns (Car[] memory) {
        return garage[_user];
    } 

    function updateCar(
        uint _index,
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint _numberOfDoors
    ) external {
        Car[] storage cars = garage[msg.sender];

        if (_index >= cars.length || cars[_index].numberOfDoors == 0) {
            revert BadCarIndex(_index);
        }

        cars[_index] = Car(
            _make,
            _model,
            _color,
            _numberOfDoors
        );
    }

    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}
