// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


/*A DoS in Ethereum means some actor (malicious user, contract, or external condition) prevents a contract or function from executing correctly — usually by causing a critical operation to fail or to run out of gas. This can lock funds, block upgrades, stop payouts, or break protocol workflows.
*/
contract Vulnarable {
    address[] public recipients;
    mapping(address => uint) public amount;

    function addRecipient(address r, uint256 a) public {
        recipients.push(r);
        amount[r] = a;
    }

    function payAll() public {
        for (uint i = 0; i < recipients.length; i++) {
            (bool succes, ) = recipients[i].call{ value: amount[recipients[i]] }("");
            require(succes, "Payment failed!");
        }
    }

    receive() external payable {}

}
