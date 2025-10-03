/*
What should we do? The solution is to change the order:

Check => Update => Action
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Safe is Ownable {
    mapping(address => uint256) public balances;

    constructor(uint256 amount) Ownable(msg.sender) {
        balances[msg.sender] = amount;
    }

    
    ///The safe function
    function withdraw(address to, uint256 amount) public  {
        ///1. Here we check if the balance has enough balance
        if(balances[msg.sender] < amount)
            revert("Not enough balance");
        /*
        2. This time we update the amount.
           Even if an attacker tries to withdraw repeatedly, the 
           blances will update
        */
        balances[to] += amount;
        balances[msg.sender] -= amount;

        ///3. Only now we send the ether
        (bool succes, ) = to.call{ value : amount}("");
        require(succes);
    }

    function getDeposit() public view {
        return address(this).balance;
    }
} 
