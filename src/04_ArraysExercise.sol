// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] public senders;
    uint[] public timestamps;

    function getNumbers() external view returns (uint[] memory) {
        return numbers;
    }

    function resetNumbers() external {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    function appendToNumbers(uint[] calldata _toAppend) external {
        for (uint i; i < _toAppend.length;) {
            numbers.push(_toAppend[i]);
            unchecked {
                ++i;
            }
        }
    }

    function saveTimestamp(uint _unixTimestamp) external {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function afterY2K() external view returns (uint[] memory, address[] memory) {
        uint totalAfterY2K;
        uint totalTimestamps = timestamps.length;
        for (uint i; i < totalTimestamps;) {
            if (timestamps[i] > 946702800) {
                unchecked {
                    ++totalAfterY2K;
                }
            }
            unchecked {
                ++i;
            }
        }

        uint[] memory timestampsToReturn = new uint[](totalAfterY2K);
        address[] memory sendersToReturn = new address[](totalAfterY2K);

        uint counter;

        for (uint i; i < totalTimestamps;) {
            if (timestamps[i] > 946702800) {
                timestampsToReturn[counter] = timestamps[i];
                sendersToReturn[counter] = senders[i];
                unchecked {
                    ++counter;
                }
            }
            unchecked {
                ++i;
            }
        }

        return (timestampsToReturn, sendersToReturn);
    }

    function resetSenders() external {
        delete senders;
    }

    function resetTimestamps() external {
        delete timestamps;
    }
}
