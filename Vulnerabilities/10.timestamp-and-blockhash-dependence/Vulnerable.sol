// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
It’s a vulnerability that occurs when a contract uses block timestamps (block.timestamp) or block hashes (blockhash) as sources of randomness or critical logic, assuming they are unpredictable.
But in reality, miners / validators have limited control over these values, so they can manipulate outcomes if profitable.
*/

contract Vulnerable {
    address payable[] public players;

    function enter() external payable {
        require(msg.value == 1 ether);
        players.push(payable(msg.sender));
    }

    function pickWinner() external {
        // Vulnerable randomness:
        uint256 index = uint256(block.timestamp) % players.length;
        address payable winner = players[index];
        winner.transfer(address(this).balance);
        delete players;
    }
}
