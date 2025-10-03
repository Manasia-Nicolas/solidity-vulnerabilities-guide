/*
There are two things that someone can do to solve this issue:
1. Make it so that the msg.sender is the owner
2. Allows only a whitelisted set of function selectors to be forwarded.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SafeForwarder {
    address public owner;
    address public target;
    mapping(bytes4 => bool) public isAllowedSelector;

    constructor(address _target) {
        require(_target != address(0), "Target is zero");
        require(_target.code.length > 0, "Target not contract");
        owner = msg.sender;
        target = _target;
    }

    function setSelectorPermission(bytes4 selector, bool allowed) external {
        require(msg.sender == owner, "Not owner");
        isAllowedSelector[selector] = allowed;
    }

    function forward(bytes calldata data) external returns (bytes memory) {
        require(target != address(0), "Target not set");
        require(data.length >= 4, "Invalid data");

        bytes4 sel;
        assembly {
            sel := calldataload(data.offset)
        }
        require(isAllowedSelector[sel], "Selector not allowed");

        (bool ok, bytes memory ret) = target.delegatecall(data);
        if (!ok) {
            assembly {
                revert(add(ret, 32), mload(ret))
            }
        }
        return ret;
    }
}
