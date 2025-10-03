/*
What are these terms?

Front-running = someone (bot/miner/validator) observes a pending transaction in the mempool and submits their own transaction with higher priority (higher gas) so it executes before the observed one, profiting from the predictable state change.

MEV (Miner/Maximal Extractable Value) = the profit that miners/validators (or searchers working with them) can extract by ordering, including, excluding, or censoring transactions in a block. MEV includes front-running, sandwiching, back-running, liquidation arbitrage, and more complex reordering strategies.

Aka an attacker can see an order that would impact the price, and if he place an call with higher gas, it will be places first. The initial order would be bought at a higher price and the attacker can after sell and take a profit.

There are a lot of cases of attacks, but I will describe sandwich.

Attacker strategy for a sandwich:
1. See User’s pending buyToken() for 10 ETH in mempool.
2. Front-run: Attacker submits buyToken() with, say, 1 ETH at higher gas so it executes before user. This moves the price up.
3. User’s transaction executes at worse price (gets fewer tokens).
4. Back-run: Attacker executes sellToken() (or effectively convert tokens back off-contract) after the user’s transaction to capture profit.
*/
/ SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vulnarable {
    ///Front-running: someone (bot/miner/validator) observes a pending transaction in the mempool and submits their own transaction with higher priority (higher gas) so it executes before the observed one, profiting from the predictable state change.
    ///MEV (Miner/Maximal Extractable Value): the profit that miners/validators (or searchers working with them) can extract by ordering, including, excluding, or censoring transactions in a block. MEV includes front-running, sandwiching, back-running, liquidation arbitrage, and more complex reordering strategies.

    uint256 public reserveToken; ///token units
    uint256 public reserveEth;   ///wei units


    mapping(address => uint256) public balancesToken;

    constructor(uint256 _token, uint256 _eth) public {
        reserveToken = _token;
        reserveEth = _eth;
    }

    // naive price: price = reserveToken / reserveEth (not realistic formula)
    // user sends ETH and gets token based on instant price
    function buyToken() external payable {
        require(msg.value > 0, "Need to buy");
        // compute amountOut with naive formula (for demonstration)
        uint256 amountOut = (msg.value * reserveToken) / reserveEth;
        require(amountOut > 0, "zero out");

        // update reserves and transfer token (no slippage check)
        reserveEth += msg.value;
        reserveToken -= amountOut;
        balancesToken[msg.sender] += amountOut;
    }
}
