// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/06_GarageManager.sol";

contract GarageManagerTest is Test {
    GarageManager public garageManager;

    function setUp() public {
        garageManager = new GarageManager();
    }

    function testAddAndUpdateCar() public {
        garageManager.resetMyGarage();
        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        garageManager.resetMyGarage();

        garageManager.addCar("Mazda", "Miata", "Silver", 2);
        garageManager.addCar("Volkswagen", "GTI", "Red", 4);

        vm.startPrank(0xba5E00000000000000000000000000000000ba5e);
        vm.expectRevert(abi.encodeWithSelector(GarageManager.BadCarIndex.selector, 0));
        garageManager.updateCar(0, "Nissan", "Skyline", "Blue", 2);

        garageManager.addCar("Ford", "Mustang", "Blue", 2);
        garageManager.addCar("Ford", "Focus", "Silver", 4);
        vm.stopPrank();

        GarageManager.Car[] memory myCars = garageManager.getUserCars(address(this));
        assertEq(myCars.length, 2);
        assertEq(myCars[0].make, "Mazda");
        assertEq(myCars[0].model, "Miata");
        assertEq(myCars[0].color, "Silver");
        assertEq(myCars[0].numberOfDoors, 2);
        assertEq(myCars[1].make, "Volkswagen");
        assertEq(myCars[1].model, "GTI");
        assertEq(myCars[1].color, "Red");
        assertEq(myCars[1].numberOfDoors, 4);

        GarageManager.Car[] memory otherCars = garageManager.getUserCars(
            address(0xba5E00000000000000000000000000000000ba5e)
        );
        assertEq(otherCars.length, 2);
        assertEq(otherCars[0].make, "Ford");
        assertEq(otherCars[0].model, "Mustang");
        assertEq(otherCars[0].color, "Blue");
        assertEq(otherCars[0].numberOfDoors, 2);
        assertEq(otherCars[1].make, "Ford");
        assertEq(otherCars[1].model, "Focus");
        assertEq(otherCars[1].color, "Silver");
        assertEq(otherCars[1].numberOfDoors, 4);

        garageManager.updateCar(0, "Mazda", "Miata", "Red", 2);
        assertEq(garageManager.getMyCars()[0].color, "Red");

        vm.expectRevert(abi.encodeWithSelector(GarageManager.BadCarIndex.selector, 5));
        garageManager.updateCar(5, "Toyota", "AE86", "White", 2);
    }
}
