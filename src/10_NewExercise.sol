// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    error ContactNotFound(uint _id);

    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    mapping(uint => Contact) private contacts;
    uint[] private contactIds;
    uint _currentId;

    constructor(address _initialOwner) {
        _transferOwnership(_initialOwner);
    }

    function addContact(
        string calldata _firstName,
        string calldata _lastName,
        uint[] calldata _phoneNumbers
    ) external onlyOwner {
        contacts[_currentId] = Contact(
            _currentId,
            _firstName,
            _lastName,
            _phoneNumbers
        );
        contactIds.push(_currentId);
        ++_currentId;
    }

    function deleteContact(
        uint _id
    ) external onlyOwner {
        if (contacts[_id].id == 0 && contactIds[_id] != 0) {
            revert ContactNotFound(_id);
        }

        delete contacts[_id];

        for (uint i; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                contactIds[i] = contactIds[contactIds.length-1];
                contactIds.pop();
            }
        }
    }

    function getContact(
        uint _id
    ) external view returns (Contact memory) {
        if (contacts[_id].id == 0 && contactIds[_id] != 0) {
            revert ContactNotFound(_id);
        }

        return contacts[_id];
    }

    function getAllContacts() external view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);

        for (uint i; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }

        return allContacts;
    }
}

contract AddressBookFactory {
    function deploy() external returns (address) {
        return address(new AddressBook(msg.sender));
    }
}
