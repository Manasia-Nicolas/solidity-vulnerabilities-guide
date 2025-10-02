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

contract Safe {
    address owner;
    constructor() public {
        owner = msg.sender;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Not owner");
        ///Always use msg.sender
        payable(tx.origin).call{ value : amount}("");
    } 
}
