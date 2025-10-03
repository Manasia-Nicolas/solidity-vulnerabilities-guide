/*
Luckly Solidity with a version bigger then 0.8.0 would revert if an overflow or underflow would happen. You can also use Safemath for older versions.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13; ///Solidity >= 0.8.0

contract Safe {
    mapping(address => uint256) public balances;

    constructor(uint256 amount) public {
        balances[msg.sender] = amount;
    }

    function transfer(address to, uint256 amount) public{
        require(balances[msg.sender] >= amount, "Not enough balance");
        balances[to] += amount;
        balances[msg.sender] -= amount;
    }
}
