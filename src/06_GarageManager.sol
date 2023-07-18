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

        if (_index >= cars.length) {
            revert BadCarIndex(_index);
        }

        /*
            Cheaper than doing:

                cars[_index] = Car(
                    _make,
                    _model,
                    _color,
                    _numberOfDoors
                );
         */
        cars[_index].make = _make;
        cars[_index].model = _model;
        cars[_index].color = _color;
        cars[_index].numberOfDoors = _numberOfDoors;
    }

    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}
