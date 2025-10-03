/*
What is tx.origin? Ussualy people believe is the same thing with msg.sender, which is an address that tells which person/contract deployed the contract in question. But tx.origin isn’t the same thing. The formal definition would be:

tx.origin = a global EVM variable that returns the original externally-owned account (EOA) that started the transaction.

But the simpler explanation is the first one that deployed the contract.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vulnarable {
    address owner;
    constructor() public {
        owner = tx.origin;
    }

    function withdraw(uint256 amount) public {
        require(tx.origin == owner, "Not owner");
        ///This should check if the owner deployed, but it only checks if the person that deployed the first contract is the owner.
        payable(tx.origin).call{ value : amount}("");
        ///So, if a intermedary contract tricks some other contract to be deployed, the owner will not be that one, so anyone can use it.
    } 
}
