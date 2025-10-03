/*
The better way is to do a pull over push (instead of having a paying function, the users should have a withdrawl function), to not have a function that calls an unboded array or to batch.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Safe {
    mapping(address => uint) public pending;

    function credit(address to, uint256 amount) internal {
        pending[to] += amount;
    }
    ///pull over push
    function withdraw() external {
        uint256 amt = pending[msg.sender];
        require(amt > 0, "No pending payments");
        pending[msg.sender] = 0;
        (bool succes, ) = msg.sender.call{ value: amt }("");
        require(succes, "Payment failed");
    }
}
