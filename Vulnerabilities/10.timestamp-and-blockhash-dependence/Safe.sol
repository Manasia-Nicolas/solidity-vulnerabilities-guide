/*
Always use true random generators that are almost impossible to predict.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Safe {
    address payable[] public players;
    mapping(address => bytes32) public commitment;
    uint256 public revealedCount;
    bytes32 public entropy;

    bool public picking;

    constructor(address vrfCoordinator, address linkToken, bytes32 _keyHash, uint256 _fee)
        VRFConsumerBase(vrfCoordinator, linkToken) {
        keyHash = _keyHash;
        fee = _fee;
    }


    function enter() external payable {
        require(msg.value == 1 ether);
        players.push(payable(msg.sender));
    }

    function commit(bytes32 hash) external {
        require(players.length > 0, "no active round");
        require(commitment[msg.sender] == bytes32(0), "already committed");
        commits[msg.sender] = hash;
    }

    function getRandom() public view returns (uint256) {
        bytes32 combined = keccak256(abi.encodePacked(randomSeeds));
        return uint256(combined);
    }

    function reveal(uint256 seed) external {
        bytes32 expected = keccak256(abi.encodePacked(seed, msg.sender));
        require(commitment[msg.sender] == expected, "bad reveal or no commit");

        // Mix this reveal into the global entropy
        entropy = keccak256(abi.encodePacked(entropy, expected));
        commitment[msg.sender] = bytes32(0); // clear so it can't be re-used
        revealedCount += 1;
    }
    
    function pickWinner() external {
        require(!picking, "picking");
        require(players.length > 0, "no players");
        require(revealedCount > 0, "no reveals yet");

        picking = true;

        uint256 randomness = uint256(entropy);
        uint256 index = randomness % players.length;
        address payable winner = players[index];
        uint256 payout = address(this).balance;

        // Effects first, then interaction
        // Reset round state before the transfer to avoid reentrancy surprises
        delete players;
        entropy = bytes32(0);
        revealedCount = 0;

        (bool ok, ) = winner.call{value: payout}("");
        require(ok, "transfer failed");

        picking = false;
    }
}
