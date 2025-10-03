// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vulnarable {
    address[] public recipients;
    mapping(address => uint) public balances;

    function addRecepient(address r, uint256 a) external {
        recipients.push(r);
        balances[r] = a;
    }

    // Danger: tries to pay everyone in one tx
    function payAll() external {
        for (uint i = 0; i < recipients.length; i++) {
            (bool succes, ) = recipients[i].call{ value: balances[recipients[i]] }("");
            require(succes, "Payment failed!");
        }
    }
    receive() external payable {}
}
