/*
An unchecked external call means the caller does not verify the result.

See from the code below that pay function doesn’t check. We should have written it like the withdraw function.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    mapping(address => uint256) public balances;

    constructor(uint256 amount){
        balances[msg.sender] = amount;
    }
    
    ///unchecked external call
    ///ignore .call succes
    function pay(address to) public payable {
        ///1. We have updated the balances
        balances[to] += msg.value;
        balances[msg.sender] -= msg.value;
        ///2. We do the call, but we don't know if it is succesful
        ///   If it fails, the balances will still be modified
        to.call{ value : msg.value}("");
    }

    function withdraw(address to) public {
        balances[to] += balances[msg.sender];
        balances[msg.sender] = 0;
        /// Here we check if it is succesful.
        /// In the case of falling, the balances will revert to the initial value
        (bool succes, ) = to.call{ value : balances[msg.sender]}("");
        require(succes);
    }
}
