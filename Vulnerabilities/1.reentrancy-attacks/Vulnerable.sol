// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Vulnarable is Ownable {
    mapping(address => uint256) public balances;

    constructor(uint256 amount) Ownable(msg.sender) {
        balances[msg.sender] = amount;
    }

    

    function withdraw(address to, uint256 amount) public  {
        if(balances[msg.sender] < amount)
            revert("Not enough balance");

        (bool succes, ) = to.call{ value : amount}("");
        require(succes);

        balances[to] += amount;
        balances[msg.sender] -= amount;
    }

    function getDeposit() public view {
        return address(this).balance;
    }
}
