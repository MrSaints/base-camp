// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    error HaikuNotUnique();
    error NoHaikusShared();
    error NotHaikuOwner();

    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    mapping(bytes32 => bool) public haikuLinesUsed;
    Haiku[] public haikus;
    mapping(address => uint256[]) public sharedHaikus;
    uint256 public counter = 1;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function mintHaiku(string calldata _line1, string calldata _line2, string calldata _line3) external {
        bytes32 line1hash = keccak256(abi.encodePacked(_line1));
        bytes32 line2hash = keccak256(abi.encodePacked(_line2));
        bytes32 line3hash = keccak256(abi.encodePacked(_line3));

        if(haikuLinesUsed[line1hash] || haikuLinesUsed[line2hash] || haikuLinesUsed[line3hash]) {
            revert HaikuNotUnique();
        }
        haikuLinesUsed[line1hash] = true;
        haikuLinesUsed[line2hash] = true;
        haikuLinesUsed[line3hash] = true;

        Haiku storage newHaiku = haikus.push();
        newHaiku.author = msg.sender;
        newHaiku.line1 = _line1;
        newHaiku.line2 = _line2;
        newHaiku.line3 = _line3;

        _mint(msg.sender, counter);

        unchecked {
            ++counter;
        }
    }

    function shareHaiku(uint256 _tokenId, address _to) external {
        if (ownerOf(_tokenId) != msg.sender) {
            revert NotHaikuOwner();
        }
        sharedHaikus[_to].push(_tokenId);
    }

    function getMySharedHaikus() external view returns (Haiku[] memory) {
        uint256[] memory haikuIds = sharedHaikus[msg.sender];
        uint256 totalShared = haikuIds.length;
        if (totalShared == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory haikusToReturn = new Haiku[](totalShared);
        for (uint256 i; i < totalShared;) {
            unchecked {
                haikusToReturn[i] = haikus[haikuIds[i] - 1];
                ++i;
            }
        }

        return haikusToReturn;
    }
}