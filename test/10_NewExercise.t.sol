// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/10_NewExercise.sol";

contract NewExerciseTest is Test {
    AddressBookFactory public factory;

    function setUp() public {
        factory = new AddressBookFactory();
    }

    function testDeployment() public {
        assertNotEq(factory.deploy(), address(0));
    }

    function testAddDelete() public {
        AddressBook addressBook = AddressBook(factory.deploy());   

        uint[] memory phoneNumbers = new uint[](1);
        phoneNumbers[0] = 2021234567;
        addressBook.addContact(
            "Brian",
            "Doyle",
            phoneNumbers
        );

        phoneNumbers[0] = 2021234555;
        addressBook.addContact(
            "Joe",
            "Smith",
            phoneNumbers
        );

        phoneNumbers[0] = 2021234571;
        addressBook.addContact(
            "Jane",
            "Doe",
            phoneNumbers
        );

        AddressBook.Contact memory contact = addressBook.getContact(0);
        assertEq(contact.id, 0);
        assertEq(contact.lastName, "Doyle");

        contact = addressBook.getContact(2);
        assertEq(contact.firstName, "Jane");
        assertEq(contact.phoneNumbers[0], 2021234571);

        addressBook.deleteContact(1);
        AddressBook.Contact[] memory contacts = addressBook.getAllContacts();
        assertEq(contacts.length, 2);
        assertEq(contacts[0].id, 0);
        assertEq(contacts[0].firstName, "Brian");
        assertEq(contacts[1].id, 2);
        assertEq(contacts[1].lastName, "Doe");
    }

    function testOnlyOwner() public {
        AddressBook addressBook = AddressBook(factory.deploy());

        uint[] memory phoneNumbers = new uint[](1);
        phoneNumbers[0] = 2021234567;

        vm.prank(0xba5E00000000000000000000000000000000ba5e);
        vm.expectRevert("Ownable: caller is not the owner");
        addressBook.addContact(
            "Brian",
            "Doyle",
            phoneNumbers
        );
    }
}
