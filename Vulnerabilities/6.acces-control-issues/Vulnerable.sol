/*
This is a more obvius vulnerability. It is when users have permisions that ussualy shouldn’t have.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vulnarable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    // Anyone can call this — not restricted!
    function destroy() public {
        selfdestruct(payable(msg.sender));
    }
    mapping(address => bool) public admins;

    function addAdmin(address _admin) public {
        // Forgot to restrict — anyone can add themselves as admin!
        admins[_admin] = true;
    }

    function withdraw(uint amount) public {
        require(admins[msg.sender], "Not admin");
        payable(msg.sender).transfer(amount);
    }

    ///Also tx.origin can be considered a Acces Control issues

}
