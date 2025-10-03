/*
This occurs when a contract allows arithmetic operations that don’t account for wrapping.

For exemple a uint8 can hold numbers from 0 to 255. If I have x = 0 and do x = x — 1, then x = 255 (uint8 can’t hold -1).

An attacker can exploit this to manipulate balances, counters, or token supply.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0; ///older version

contract Vulnerable {
    mapping(address => uint256) public balances;

    constructor(uint256 amount) public {
        balances[msg.sender] = amount;
    }

    function transfer(address to, uint256 amount) public{
        ///if Solidy < 0.8.0, the require wouldn't revert
        require(balances[msg.sender] >= amount, "Not enough balance");
        balances[to] += amount;
        balances[msg.sender] -= amount;
    }
}
